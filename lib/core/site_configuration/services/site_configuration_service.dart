import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/site_configuration/models/site_configuration_model.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';

class SiteConfigurationService {
  SiteConfigurationService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<SiteConfigurationModel?> fetchConfiguration() async {
    final token = StorageService.token;
    if (token == null || token.isEmpty) {
      return null;
    }

    final response = await _networkCaller.getRequest(
      ApiConstants.siteConfiguration,
      headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
    );

    if (!response.isSuccess || response.responseData is! Map) {
      return null;
    }

    final responseBody = Map<String, dynamic>.from(
      response.responseData as Map,
    );
    if (responseBody['success'] == false) {
      return null;
    }

    return SiteConfigurationModel.fromJson(responseBody);
  }
}
