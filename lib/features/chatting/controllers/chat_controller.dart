import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/features/chatting/data/services/chat_service.dart';
import 'package:quikle_user/features/chatting/data/models/message.dart';
import 'dart:convert';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
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
        try {
          final json = jsonDecode(message);
          final msg = Message.fromJson(json, false);
          messages.add(msg);
        } catch (e) {
          messages.add(
            Message(text: 'Error parsing message: $message', isSent: false),
          );
        }
      },
      (error) {
        messages.add(Message(text: 'Error: $error', isSent: false));
      },
      () {
        messages.add(Message(text: 'Connection closed', isSent: false));
      },
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final msg = Message(
        text: messageController.text,
        isSent: true,
        timestamp: DateTime.now().toIso8601String(),
      );
      _chatService.sendMessage(messageController.text);
      messages.add(msg);
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
