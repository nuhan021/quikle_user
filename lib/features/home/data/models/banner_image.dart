class BannerImage {
  final int id;
  final String imageUrl;

  BannerImage({required this.id, required this.imageUrl});

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}
