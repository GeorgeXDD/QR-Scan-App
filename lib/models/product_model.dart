class Product {
  String? itemId;
  String? title;
  String? imageUrl;
  String? itemWebUrl;
  String? priceValue;
  String? currency;
  String? source;
  bool isFavorited;
  double? score;
  int? reviewCount;

  Product({
    this.itemId,
    this.title,
    this.imageUrl,
    this.itemWebUrl,
    this.priceValue,
    this.currency,
    this.isFavorited = false,
    this.score,
    this.reviewCount,
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
        score: json['score'] as double?,
        reviewCount: json['reviewCount'] as int?);
  }

  factory Product.fromFirestoreReview(Map<String, dynamic> firestoreData) {
    return Product(
        itemId: firestoreData['itemId'] as String?,
        title: firestoreData['title'] as String?,
        imageUrl: firestoreData['imageUrl'] as String?,
        itemWebUrl: firestoreData['itemWebUrl'] as String?,
        score: firestoreData['score'] as double?,
        reviewCount: firestoreData['reviewCount'] as int?);
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
