import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/data/services/category_cache_service.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class PrefetchConfig {
  final int concurrency;
  final int perCategoryMaxPagesOnCellular;
  final bool allowFullOnCellular;
  final Duration perRequestDelay;

  const PrefetchConfig({
    this.concurrency = 2,
    this.perCategoryMaxPagesOnCellular = 5,
    this.allowFullOnCellular = true,
    this.perRequestDelay = const Duration(milliseconds: 300),
  });
}

class _PrefetchJob {
  final String categoryId;
  final bool full; // whether to fetch until server says no more
  _PrefetchJob(this.categoryId, {this.full = false});
}

class GlobalPrefetchService {
  GlobalPrefetchService._internal();
  static final GlobalPrefetchService instance =
      GlobalPrefetchService._internal();

  final PrefetchConfig config = const PrefetchConfig();
  final _queue = <_PrefetchJob>[];
  final _running = <String>{};
  bool _loopRunning = false;

  final ProductDataService _productDataService = ProductDataService();
  final CategoryCacheService _cacheService = CategoryCacheService();

  final Connectivity _connectivity = Connectivity();

  void enqueueCategory(String categoryId, {bool full = false}) {
    if (_queue.any((j) => j.categoryId == categoryId) ||
        _running.contains(categoryId))
      return;
    _queue.add(_PrefetchJob(categoryId, full: full));
    _startLoop();
  }

  void _startLoop() {
    if (_loopRunning) return;
    _loopRunning = true;
    Future(() async {
      while (_loopRunning && _queue.isNotEmpty) {
        if (_running.length >= config.concurrency) {
          await Future.delayed(const Duration(milliseconds: 200));
          continue;
        }

        final job = _queue.removeAt(0);
        _runJob(job);
      }
      _loopRunning = false;
    });
  }

  void _runJob(_PrefetchJob job) {
    _running.add(job.categoryId);
    Future(() async {
      try {
        final conn = await _connectivity.checkConnectivity();
        final onWifi = conn == ConnectivityResult.wifi;

        int page = 0;
        bool hasMore = true;
        int pagesFetched = 0;

        // Decide whether to apply a cellular cap. If the config explicitly
        // allows full prefetch on cellular, we won't apply a cap.
        final applyCellularCap = !onWifi && !config.allowFullOnCellular;
        final maxPages = job.full && applyCellularCap
            ? config.perCategoryMaxPagesOnCellular
            : null;

        while (hasMore) {
          page += 1;
          final result = await _productDataService.fetchMoreProducts(
            categoryId: job.categoryId,
            offset: (page - 1) * 20,
            limit: 20,
          );

          final newProducts = result['products'] as List?;
          final fetchedHasMore = result['hasMore'] as bool? ?? false;

          if (newProducts != null && newProducts.isNotEmpty) {
            // Merge with existing cache so we keep previously cached pages.
            try {
              final existing = await _cacheService.getCachedProducts(
                categoryId: job.categoryId,
              );

              final merged = <ProductModel>[];
              if (existing != null && existing.isNotEmpty) {
                merged.addAll(existing);
              }

              // newProducts should be List<ProductModel>
              final fetched = newProducts.cast<ProductModel>();
              merged.addAll(fetched);

              // Deduplicate by product id while preserving order
              final map = <String, ProductModel>{};
              for (final p in merged) {
                if (!map.containsKey(p.id)) map[p.id] = p;
              }
              final unique = map.values.toList();

              // Save merged unique list back to cache
              await _cacheService.cacheProducts(
                categoryId: job.categoryId,
                products: unique,
              );
            } catch (_) {
              // Fallback: cache just the latest page (as ProductModel list)
              try {
                await _cacheService.cacheProducts(
                  categoryId: job.categoryId,
                  products: newProducts.cast<ProductModel>(),
                );
              } catch (_) {}
            }
          }

          pagesFetched += 1;
          hasMore = fetchedHasMore;

          // stop if we reached a safety cap
          if (maxPages != null && pagesFetched >= maxPages) break;

          // brief throttle between requests
          await Future.delayed(config.perRequestDelay);
        }
      } catch (_) {
        // swallow errors for background prefetch; could add retry/backoff later
      } finally {
        _running.remove(job.categoryId);
      }
    });
  }

  void stop() {
    _loopRunning = false;
    _queue.clear();
  }
}
