import 'package:get/get.dart';
import '../../data/models/banner_image.dart';
import '../../data/services/banner_service.dart';

class OfferBannerController extends GetxController {
  final BannerService _service;
  OfferBannerController({BannerService? service})
    : _service = service ?? BannerService();

  final RxList<BannerImage> banners = <BannerImage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchBanners({int initialLimit = 5}) async {
    isLoading.value = true;
    error.value = '';
    try {
      final firstPage = await _service.fetchBannersPage(1, initialLimit);
      banners.assignAll(firstPage.items);
      final int totalPages = firstPage.totalPages;
      if (totalPages <= 1) return;
      Future(() async {
        int page = 2;
        const int subsequentLimit = 10;
        while (page <= totalPages) {
          try {
            final next = await _service.fetchBannersPage(page, subsequentLimit);
            if (next.items.isEmpty) break;
            banners.addAll(next.items);
            page++;
          } catch (e) {
            error.value = e.toString();
            break;
          }
        }
      });
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
