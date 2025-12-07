import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';

class NotificationService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<ResponseData> saveFCMToken(String token) async {
    try {
      final userid = StorageService.userId;
      final response = await _networkCaller.postRequest(
        ApiConstants.saveFcmToken,
        body: {'fcm_token': token, 'platform': 'android', 'user_id': userid},
      );
      return response;
    } catch (e) {
      // Handle error if necessary
      rethrow;
    }
  }
}
