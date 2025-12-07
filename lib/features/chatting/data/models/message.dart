class Message {
  final String text;
  final bool isSent;
  final String? timestamp;
  final String? messageId;
  final String? fromName;

  Message({
    required this.text,
    required this.isSent,
    this.timestamp,
    this.messageId,
    this.fromName,
  });

  factory Message.fromJson(Map<String, dynamic> json, bool isSent) {
    return Message(
      text: json['text'] ?? '',
      isSent: isSent,
      timestamp: json['timestamp'],
      messageId: json['message_id'],
      fromName: json['from_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'to_type': 'riders',
      'to_id': '', // will be set in service
    };
  }
}
