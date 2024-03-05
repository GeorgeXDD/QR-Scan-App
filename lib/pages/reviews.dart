import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';
import '../services/reviews_service.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final ReviewService _reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272829),
      appBar: AppBar(
        title: Text('Reviews',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Color(0xFF272829),
      ),
      body: StreamBuilder<List<Review>>(
        stream: _reviewService.fetchReviews(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final reviews = snapshot.data!;
          if (reviews.isEmpty) {
            return Center(
              child: Text(
                "No reviews yet. Be the first to leave a review!",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: EdgeInsets.all(8.0),
                color: Colors.grey[850],
                child: ListTile(
                  leading: Image.network(review.imageUrl,
                      width: 100, height: 100, fit: BoxFit.cover),
                  title:
                      Text(review.title, style: TextStyle(color: Colors.white)),
                  subtitle: Text('Score: ${review.score}',
                      style: TextStyle(color: Colors.white70)),
                  onTap: () {
                    // Implement navigation to review details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
