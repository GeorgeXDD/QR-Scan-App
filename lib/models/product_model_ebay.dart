class Product {
  final String title;
  final String imageUrl;
  final String itemWebUrl;
  final String priceValue;
  final String currency;

  Product({
    required this.title,
    required this.imageUrl,
    required this.itemWebUrl,
    required this.priceValue,
    required this.currency,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var valueData = json['price'] ?? {};
    var imageData = json['image'] ?? {};
    return Product(
      title: json['title'] ?? 'Product not found',
      imageUrl: imageData['imageUrl'] ?? 'https://via.placeholder.com/150',
      itemWebUrl: json['itemWebUrl'],
      priceValue: valueData['value'] ?? 0.0,
      currency: valueData['currency'] ?? '',
    );
  }
}
