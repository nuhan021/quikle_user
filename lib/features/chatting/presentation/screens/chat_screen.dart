import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/chatting/controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.riderId});

  final String riderId;

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController(riderId: riderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Rider')),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(controller.messages[index]));
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
