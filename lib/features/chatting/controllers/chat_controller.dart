import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/features/chatting/data/services/chat_service.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final RxList<String> messages = <String>[].obs;
  late ChatService _chatService;
  final String riderId;

  ChatController({required this.riderId});

  @override
  void onInit() {
    super.onInit();
    final customerId = StorageService.userId?.toString() ?? '1';
    _chatService = ChatService(customerId: customerId, riderId: riderId);
    _connect();
  }

  void _connect() {
    _chatService.connect(
      (message) {
        messages.add('Received: $message');
      },
      (error) {
        messages.add('Error: $error');
      },
      () {
        messages.add('Connection closed');
      },
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      _chatService.sendMessage(messageController.text);
      messages.add('Sent: ${messageController.text}');
      messageController.clear();
    }
  }

  @override
  void onClose() {
    _chatService.disconnect();
    messageController.dispose();
    super.onClose();
  }
}
