class RestaurantModel {
  final String id;
  final String name;
  final String image;
  final String deliveryTime;
  final double rating;
  final String address;
  final bool isOpen;
  final List<String> cuisines;
  final List<String> specialties; // Food categories they serve
  final int reviewCount;
  final double popularity; // Score for ranking
  final bool isTopRated;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    required this.deliveryTime,
    required this.rating,
    required this.address,
    this.isOpen = true,
    required this.cuisines,
    required this.specialties,
    this.reviewCount = 0,
    this.popularity = 0.0,
    this.isTopRated = false,
  });

  // Helper method to check if restaurant serves a specific food category
  bool servesCategory(String categoryId) {
    return specialties.contains(categoryId);
  }

  // Calculate popularity score based on rating and review count
  double get popularityScore {
    return (rating * 0.7) + (reviewCount / 100 * 0.3);
  }
}
