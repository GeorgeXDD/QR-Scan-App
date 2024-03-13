import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String itemId;
  String title;
  String description;
  double score;
  String imageUrl;
  String itemUrl;
  String userId;
  String username;

  Review({
    required this.itemId,
    required this.title,
    required this.description,
    required this.score,
    required this.imageUrl,
    required this.itemUrl,
    required this.userId,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'title': title,
      'description': description,
      'score': score,
      'imageUrl': imageUrl,
      'itemUrl': itemUrl,
      'userId': userId,
      'username': username,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      itemId: map['itemId'],
      title: map['title'],
      description: map['description'],
      score: map['score'].toDouble(),
      imageUrl: map['imageUrl'],
      itemUrl: map['itemUrl'],
      userId: map['userId'],
      username: map['username'],
    );
  }

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Review(
      itemId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      score: data['score'].toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      itemUrl: data['itemUrl'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
