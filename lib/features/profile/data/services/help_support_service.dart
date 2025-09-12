import 'package:get/get.dart';
import '../models/faq_model.dart';
import '../models/support_ticket_model.dart';

class HelpSupportService extends GetxController {
  static HelpSupportService get instance => Get.find<HelpSupportService>();
  final List<SupportTicketModel> _submittedTickets = [];

  List<FaqModel> getFaqs() {
    return [
      const FaqModel(
        id: 'faq_1',
        question: 'How do I place an order?',
        answer:
            'To place an order, simply browse our products, add items to your cart, and proceed to checkout. You can pay using various payment methods including credit cards, digital wallets, or cash on delivery.',
      ),
      const FaqModel(
        id: 'faq_2',
        question: 'How can I track my delivery?',
        answer:
            'Once your order has been shipped, you\'ll receive a tracking number via SMS and email. You can use this number to track your delivery status in real-time through our app or website.',
      ),
      const FaqModel(
        id: 'faq_3',
        question: 'What payment methods are accepted?',
        answer:
            'We accept all major credit cards, debit cards, digital wallets like Paytm, PhonePe, Google Pay, and also offer cash on delivery option for your convenience.',
      ),
      const FaqModel(
        id: 'faq_4',
        question: 'What should I do if an item is out of stock?',
        answer:
            'For out-of-stock items, you can select the "Notify me" option to get alerts when the item is back in stock. You can also check similar products or contact our support team for alternatives.',
      ),
    ];
  }

  List<SupportTicketModel> getRecentSupportHistory() {
    final mockTickets = [
      SupportTicketModel(
        id: 'ticket_1',
        title: 'Order #12345 Issue',
        description: 'Issue with order delivery time',
        issueType: SupportIssueType.orderIssue,
        status: SupportTicketStatus.resolved,
        submittedAt: DateTime(2023, 5, 15),
        resolvedAt: DateTime(2023, 5, 16),
      ),
      SupportTicketModel(
        id: 'ticket_2',
        title: 'Payment Method Update',
        description: 'Unable to update payment method',
        issueType: SupportIssueType.paymentIssue,
        status: SupportTicketStatus.inProgress,
        submittedAt: DateTime(2023, 6, 2),
      ),
    ];

    final allTickets = [...mockTickets, ..._submittedTickets];
    allTickets.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));

    return allTickets;
  }

  Future<bool> submitSupportTicket({
    required SupportIssueType issueType,
    required String description,
    String? attachmentPath,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final newTicket = SupportTicketModel(
        id: 'ticket_${DateTime.now().millisecondsSinceEpoch}',
        title: issueType.label,
        description: description,
        issueType: issueType,
        status: SupportTicketStatus.pending,
        submittedAt: DateTime.now(),
        attachmentPath: attachmentPath,
      );

      _submittedTickets.add(newTicket);
      return true;
    } catch (e) {
      print('Error submitting support ticket: $e');
      return false;
    }
  }

  Future<String?> uploadAttachment(String filePath) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      //return 'https:
    } catch (e) {
      print('Error uploading attachment: $e');
      return null;
    }
  }
}
