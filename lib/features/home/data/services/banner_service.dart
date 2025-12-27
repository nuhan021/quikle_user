import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import '../models/banner_image.dart';

class BannerService {
  Future<List<BannerImage>> fetchBanners() async {
    const int pageSize = 50;
    int page = 1;
    final List<BannerImage> all = [];
    while (true) {
      final pageResult = await fetchBannersPage(page, pageSize);
      if (pageResult.items.isEmpty) break;
      all.addAll(pageResult.items);
      if (page >= pageResult.totalPages) break;
      page++;
    }
    return all;
  }

  Future<BannerPageResult> fetchBannersPage(int page, int limit) async {
    final token = StorageService.token;
    final uri = Uri.parse(
      '${ApiConstants.getBannerImages}?page=$page&limit=$limit',
    );
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load banners (page $page)');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    final pictures = data['pictures'] as List<dynamic>;
    final items = pictures
        .map((e) => BannerImage.fromJson(e as Map<String, dynamic>))
        .toList();
    final totalPages = (data['total_pages'] is int)
        ? data['total_pages'] as int
        : int.tryParse('${data['total_pages']}') ?? 1;
    final currentPage = (data['page'] is int)
        ? data['page'] as int
        : int.tryParse('${data['page']}') ?? page;
    return BannerPageResult(
      items: items,
      page: currentPage,
      totalPages: totalPages,
    );
  }
}

class BannerPageResult {
  final List<BannerImage> items;
  final int page;
  final int totalPages;

  BannerPageResult({
    required this.items,
    required this.page,
    required this.totalPages,
  });
}
