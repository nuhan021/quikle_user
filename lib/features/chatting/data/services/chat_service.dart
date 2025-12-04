import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatService {
  late WebSocketChannel _channel;
  final String customerId;
  final String riderId;

  ChatService({required this.customerId, required this.riderId});

  void connect(
    Function(String) onMessageReceived,
    Function onError,
    Function onDone,
  ) {
    final url =
        'wss://quikle-u4dv.onrender.com/rider/ws/chat/customers/$customerId';
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

  void sendMessage(String text) {
    final message = {"to_type": "riders", "to_id": riderId, "text": text};
    _channel.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel.sink.close();
  }
}
