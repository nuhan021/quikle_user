import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/chatting/controllers/chat_controller.dart';
import 'package:quikle_user/features/chatting/presentation/widgets/chat_header.dart';
import 'package:quikle_user/features/chatting/presentation/widgets/messages_list.dart';
import 'package:quikle_user/features/chatting/presentation/widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.rider, this.riderId});

  final dynamic rider;
  final String? riderId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController controller;
  final ScrollController _scrollController = ScrollController();

  bool _isDisplayable(dynamic message) {
    try {
      final text = (message?.text ?? '').toString().trim();
      if (text.isEmpty) return false;
      final low = text.toLowerCase();
      if (low == 'ping' ||
          low == 'pong' ||
          low == 'heartbeat' ||
          low == 'keepalive')
        return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  String _formatTimestamp(dynamic ts) {
    try {
      if (ts == null) return '';
      DateTime dt;
      if (ts is DateTime) {
        dt = ts;
      } else if (ts is int) {
        dt = DateTime.fromMillisecondsSinceEpoch(ts);
      } else {
        dt = DateTime.parse(ts.toString());
      }

      final local = dt.toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(local.year, local.month, local.day);
      final daysDiff = today.difference(msgDay).inDays;

      if (daysDiff == 0) return DateFormat('h:mm a').format(local);
      if (daysDiff == 1)
        return 'Yesterday ${DateFormat('h:mm a').format(local)}';
      if (daysDiff < 7) return DateFormat('EEE h:mm a').format(local);
      return DateFormat('dd MMM, h:mm a').format(local);
    } catch (_) {
      return ts?.toString() ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    String rid = '';
    try {
      if (widget.riderId != null && widget.riderId!.isNotEmpty) {
        rid = widget.riderId!;
      } else if (widget.rider == null) {
        rid = '';
      } else if (widget.rider is Map) {
        rid = (widget.rider['riderId'] ?? widget.rider['id'] ?? '').toString();
      } else {
        final dyn = widget.rider;
        rid = (dyn.riderId ?? dyn.id ?? '').toString();
      }
    } catch (_) {
      rid = '';
    }

    controller = Get.put(ChatController(riderId: rid));
    ever(controller.messages, (_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final riderName = () {
      try {
        if (widget.rider == null) return 'Rider';
        if (widget.rider is Map)
          return (widget.rider['riderName'] ?? widget.rider['name'] ?? 'Rider')
              .toString();
        final dyn = widget.rider;
        return (dyn.riderName ?? dyn.name ?? 'Rider').toString();
      } catch (_) {
        return 'Rider';
      }
    }();

    AppLoggerHelper.debug('Opening chat screen for rider: $riderName');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ChatHeader(riderName: riderName, onBack: () => Get.back()),
                Expanded(
                  child: MessagesList(
                    controller: controller,
                    scrollController: _scrollController,
                    riderName: riderName,
                    formatTimestamp: _formatTimestamp,
                    isDisplayable: _isDisplayable,
                  ),
                ),
                ChatInput(controller: controller, riderName: riderName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
