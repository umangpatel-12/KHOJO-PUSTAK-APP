class CategoryModel{
  final String cname;
  final String? subcategory;
  final String? imageUrl;

  CategoryModel({
    required this.cname,
    this.subcategory,
    this.imageUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'cname': cname,
      'subcategory': subcategory,
      'imageUrl': imageUrl,
    };
  }
}