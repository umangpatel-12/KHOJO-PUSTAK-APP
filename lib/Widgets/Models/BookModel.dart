class BookModel {
  final String title;
  final String? author;
  final String category;
  final List<String> images;
  final String description;
  final double price;
  final double? oldprice;
  final String condition;
  final bool isFavorite;
  final String location;
  final String phone;
  final String userId;

  const BookModel({
    required this.title,
    this.author,
    required this.category,
    required this.images,
    required this.description,
    required this.condition,
    required this.location,
    required this.phone,
    required this.price,
    required this.userId,
    this.oldprice,
    this.isFavorite = false,
  });

  factory BookModel.fromDocument(Map<String, dynamic> data, String docId) {
    return BookModel(
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      images: data['images'] ?? '',
      price: data['price'] ?? 0,
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      condition: data['userId'] ?? '',
      location: data['location'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}