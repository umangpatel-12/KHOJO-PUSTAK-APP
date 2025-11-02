class BookModel {
  final String id;
  final String title;
  final String? author;
  final String category;
  final List<String> images;
  final String description;
  final String price;
  final String originalPrice;
  final String condition;
  final bool isFavorite;
  final String location;
  final String phone;
  final String userId;

  const BookModel({
    required this.id,
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
    required this.originalPrice,
    this.isFavorite = false,
  });

  factory BookModel.fromDocument(Map<String, dynamic> data, String docId) {
    return BookModel(
      id: docId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      images: data['images'] ?? '',
      price: data['price'] ?? 0,
      originalPrice: data['originalPrice'] ?? 0,
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      condition: data['userId'] ?? '',
      location: data['location'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}