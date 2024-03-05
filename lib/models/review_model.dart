class Review {
  final String id;
  final String itemId;
  final String title;
  final String description;
  final String imageUrl;
  final double score;

  Review({
    required this.id,
    required this.itemId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.score,
  });

  factory Review.fromMap(Map<String, dynamic> data, String id) {
    return Review(
      id: id,
      itemId: data['itemId'],
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      score: data['score'].toDouble(),
    );
  }
}
