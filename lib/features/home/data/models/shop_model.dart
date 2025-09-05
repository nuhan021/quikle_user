class ShopModel {
  final String id;
  final String name;
  final String image;
  final String deliveryTime;
  final double rating;
  final String address;
  final bool isOpen;

  const ShopModel({
    required this.id,
    required this.name,
    required this.image,
    required this.deliveryTime,
    required this.rating,
    required this.address,
    this.isOpen = true,
  });
}
