class Product {
  String? itemId;
  String? title;
  String? imageUrl;
  String? itemWebUrl;
  String? priceValue;
  String? currency;
  bool isFavorited;

  Product({
    this.itemId,
    this.title,
    this.imageUrl,
    this.itemWebUrl,
    this.priceValue,
    this.currency,
    this.isFavorited = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var image = json['image'] ?? {};
    var price = json['price'] ?? {};
    return Product(
      itemId: json['itemId'] as String?,
      title: json['title'] as String?,
      imageUrl: image['imageUrl'] as String?,
      itemWebUrl: json['itemWebUrl'] as String?,
      priceValue: price['value'] as String?,
      currency: price['currency'] as String?,
      isFavorited: false,
    );
  }

  factory Product.fromFirestore(Map<String, dynamic> json) {
    return Product(
      itemId: json['itemId'] as String?,
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      itemWebUrl: json['itemWebUrl'] as String?,
      priceValue: json['priceValue'] as String?,
      currency: json['currency'] as String?,
      isFavorited: json['isFavorited'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId ?? '0',
      'title': title ?? 'N/A',
      'imageUrl': imageUrl ?? 'https://via.placeholder.com/150',
      'itemWebUrl': itemWebUrl ?? '',
      'priceValue': priceValue ?? '0',
      'currency': currency ?? '',
      'isFavorited': isFavorited,
    };
  }

  void toggleFavoriteStatus() {
    isFavorited = !isFavorited;
  }
}
