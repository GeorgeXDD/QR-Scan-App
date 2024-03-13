import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewDetailsPage extends StatefulWidget {
  final String itemId;
  final String imageUrl;
  final String itemUrl;

  ReviewDetailsPage(
      {required this.itemId, required this.imageUrl, required this.itemUrl});

  @override
  _ReviewDetailsPageState createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _score = 1.0;

  Future<Review?> _fetchReview() async {
    var reviewSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .doc(widget.itemId)
        .get();

    if (reviewSnapshot.exists) {
      return Review.fromMap(reviewSnapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      var userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userProfile')
          .doc(userId)
          .get();
      var username = userSnapshot.data()?['username'] ?? '';

      final review = Review(
        itemId: widget.itemId,
        title: _title,
        description: _description,
        score: _score,
        imageUrl: widget.imageUrl,
        itemUrl: widget.itemUrl,
        userId: userId,
        username: username,
      );

      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.itemId)
          .set(review.toMap());

      Navigator.pop(context);
    }
  }

  Future<void> _deleteReview() async {
    await FirebaseFirestore.instance
        .collection('reviews')
        .doc(widget.itemId)
        .delete();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Details'),
        backgroundColor: Color(0xFF272829),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Review Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onChanged: (value) => setState(() => _title = value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Review Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                onChanged: (value) => setState(() => _description = value),
              ),
              Slider(
                value: _score,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                label: _score.toString(),
                onChanged: (double value) => setState(() => _score = value),
              ),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
              ElevatedButton(
                onPressed: _deleteReview,
                child: Text('Delete Review'),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
