import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/enums/refund_enums.dart';
import 'package:quikle_user/features/orders/data/models/refund/cancellation_eligibility_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/refund_info_model.dart';
import 'package:quikle_user/features/orders/data/models/refund/issue_report_model.dart';
import 'package:quikle_user/features/orders/data/models/order/order_model.dart';
import 'package:quikle_user/features/orders/data/models/order/grouped_order_model.dart';
import 'package:quikle_user/features/orders/data/services/refund/refund_service.dart';

/// Controller for managing refund and cancellation operations
/// All operations are API-ready through RefundService
class RefundController extends GetxController {
  final RefundService _refundService = RefundService();

  // Observable states
  final _isLoadingEligibility = false.obs;
  final _isCancelling = false.obs;
  final _isSubmittingIssue = false.obs;
  final _isLoadingRefundStatus = false.obs;

  final _cancellationEligibility = Rx<CancellationEligibility?>(null);
  final _refundInfo = Rx<RefundInfo?>(null);
  final _selectedCancellationReason = Rx<CancellationReason?>(null);
  final _selectedIssueType = Rx<IssueType?>(null);

  // Getters
  bool get isLoadingEligibility => _isLoadingEligibility.value;
  bool get isCancelling => _isCancelling.value;
  bool get isSubmittingIssue => _isSubmittingIssue.value;
  bool get isLoadingRefundStatus => _isLoadingRefundStatus.value;
  CancellationEligibility? get cancellationEligibility =>
      _cancellationEligibility.value;
  RefundInfo? get refundInfo => _refundInfo.value;
  CancellationReason? get selectedCancellationReason =>
      _selectedCancellationReason.value;
  IssueType? get selectedIssueType => _selectedIssueType.value;

  /// Check if order can be cancelled and get refund impact
  Future<void> checkCancellationEligibility(OrderModel order) async {
    try {
      _isLoadingEligibility.value = true;
      final eligibility = await _refundService.getCancellationEligibility(
        order,
      );
      _cancellationEligibility.value = eligibility;
    } catch (e) {
      print('Error checking cancellation eligibility: $e');
      Get.snackbar(
        'Error',
        'Failed to check cancellation eligibility',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoadingEligibility.value = false;
    }
  }

  /// Check if grouped orders can be cancelled and get refund impact
  /// Uses the total amount of all orders in the group for refund calculation
  Future<void> checkCancellationEligibilityForGroup(
    GroupedOrderModel groupedOrder,
  ) async {
    try {
      _isLoadingEligibility.value = true;
      final eligibility = await _refundService
          .getCancellationEligibilityForGroup(groupedOrder);
      _cancellationEligibility.value = eligibility;
    } catch (e) {
      print('Error checking group cancellation eligibility: $e');
      Get.snackbar(
        'Error',
        'Failed to check cancellation eligibility',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoadingEligibility.value = false;
    }
  }

  /// Request order cancellation
  Future<bool> requestCancellation({
    required String orderId,
    required CancellationReason reason,
    String? customNote,
  }) async {
    try {
      _isCancelling.value = true;
      final result = await _refundService.requestCancellation(
        orderId: orderId,
        reason: reason,
        customNote: customNote,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Order Cancelled',
          result['message'] ?? 'Your order has been cancelled',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Cancellation Failed',
          result['message'] ?? 'Failed to cancel order',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print('Error requesting cancellation: $e');
      Get.snackbar(
        'Error',
        'Failed to cancel order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isCancelling.value = false;
    }
  }

  /// Load refund status for an order
  Future<void> loadRefundStatus(String orderId) async {
    try {
      _isLoadingRefundStatus.value = true;
      final refundStatus = await _refundService.getRefundStatus(orderId);
      _refundInfo.value = refundStatus;
    } catch (e) {
      print('Error loading refund status: $e');
      Get.snackbar(
        'Error',
        'Failed to load refund status',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoadingRefundStatus.value = false;
    }
  }

  /// Submit an issue report
  Future<Map<String, dynamic>?> submitIssueReport({
    required IssueReport report,
  }) async {
    try {
      _isSubmittingIssue.value = true;
      final result = await _refundService.createIssueReport(report: report);

      if (result['success'] == true) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      _isSubmittingIssue.value = false;
    }
  }

  /// Upload photo for issue report
  Future<String?> uploadIssuePhoto(String localPath) async {
    try {
      return await _refundService.uploadIssuePhoto(localPath);
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  /// Select cancellation reason
  void selectCancellationReason(CancellationReason reason) {
    _selectedCancellationReason.value = reason;
  }

  /// Select issue type
  void selectIssueType(IssueType type) {
    _selectedIssueType.value = type;
  }

  /// Clear all selections and state
  void clearState() {
    _cancellationEligibility.value = null;
    _refundInfo.value = null;
    _selectedCancellationReason.value = null;
    _selectedIssueType.value = null;
  }
}
