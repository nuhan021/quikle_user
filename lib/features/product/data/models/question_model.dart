class QuestionModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userImage;
  final String question;
  final String answer;
  final DateTime date;

  const QuestionModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.question,
    required this.answer,
    required this.date,
  });

  // Helper method to get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
