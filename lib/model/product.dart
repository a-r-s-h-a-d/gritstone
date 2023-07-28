class Product {
  final int id;
  final String title;
  final double price;
  final String brand;
  final String category;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.brand,
    required this.category,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      brand: json['brand'],
      category: json['category'],
      discountPercentage: json['discountPercentage'].toDouble(),
      rating: json['rating'].toDouble(),
      stock: json['stock'],
      thumbnail: json['thumbnail'],
    );
  }
}
