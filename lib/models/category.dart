class Category {
  final String id;
  final String name;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory']?.toString() ?? '',
      name: json['strCategory']?.toString() ?? '',
      imageUrl: json['strCategoryThumb']?.toString() ?? '',
    );
  }
}
