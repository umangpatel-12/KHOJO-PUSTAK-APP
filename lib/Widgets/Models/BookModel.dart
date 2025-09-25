class BookModel {
  final String name;
  final String? author;
  final String category;
  final String imageUrl;
  final String description;
  final double price;
  final double? oldprice;
  final String condition;
  final bool isFavorite;
  final String location;
  final String phoneNumber;

  const BookModel({
    required this.name,
    this.author,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.condition,
    required this.location,
    required this.phoneNumber,
    required this.price,
    this.oldprice,
    this.isFavorite = false,
  });
}