class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userImage;
  final double? rating; // Nullable because replies don't have ratings
  final String comment;
  final DateTime date;
  final String? parentId; // For replies to reviews
  final bool isReply;
  final List<ReviewModel> replies;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userImage,
    this.rating,
    required this.comment,
    required this.date,
    this.parentId,
    this.isReply = false,
    this.replies = const [],
  });

  /// Factory constructor to create ReviewModel from API JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'].toString(),
      productId: json['item_id'].toString(),
      userId: json['user_id'].toString(),
      userName:
          'User ${json['user_id']}', // Default, should be fetched from user profile
      userImage: 'assets/icons/profile.png', // Default placeholder
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      comment: json['comment'] ?? '',
      date: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      parentId: json['parent_id']?.toString(),
      isReply: json['is_reply'] ?? false,
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((reply) => ReviewModel.fromJson(reply))
                .toList()
          : [],
    );
  }

  /// Convert ReviewModel to JSON (for local storage or API submission)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': productId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'parent_id': parentId,
      'created_at': date.toIso8601String(),
      'is_reply': isReply,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }

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
