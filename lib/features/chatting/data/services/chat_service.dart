import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/features/chatting/data/models/message.dart';

class ChatService {
  late WebSocketChannel _channel;
  final String customerId;
  final String riderId;

  ChatService({required this.customerId, required this.riderId});

  /// Fetch chat history between the customer and rider.
  Future<List<Message>> fetchHistory({int limit = 50}) async {
    try {
      final token = StorageService.token;
      final url = Uri.parse(
        'https://caditya619-backend-ng0e.onrender.com/rider/chat/history/customers/$customerId/riders/$riderId?limit=$limit',
      );

      final headers = <String, String>{'accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final resp = await http.get(url, headers: headers);
      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        final List msgs = body['messages'] ?? [];
        return msgs.map<Message>((m) {
          final fromType = (m['from_type'] ?? '').toString();
          final fromId = (m['from_id'] ?? '').toString();
          final isSent = (fromType == 'customers' && fromId == customerId);
          return Message.fromJson(Map<String, dynamic>.from(m), isSent);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void connect(
    Function(String) onMessageReceived,
    Function onError,
    Function onDone,
  ) {
    final url =
        'wss://caditya619-backend-ng0e.onrender.com/rider/ws/chat/customers/$customerId';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (message) {
        onMessageReceived(message);
      },
      onError: (error) {
        onError(error);
      },
      onDone: () {
        onDone();
      },
    );
  }

  void sendMessage(String text, String riderId) {
    final message = {"to_type": "riders", "to_id": riderId, "text": text};
    _channel.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel.sink.close();
  }
}
