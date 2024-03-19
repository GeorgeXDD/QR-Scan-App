import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_app/pages/leaveReview.dart';
import '../models/review_model.dart';

class ReviewDetailsPage extends StatefulWidget {
  final String itemId;
  final String title;
  final String imageUrl;
  final String itemWebUrl;

  ReviewDetailsPage(
      {required this.itemId,
      required this.title,
      required this.imageUrl,
      required this.itemWebUrl});

  @override
  _ReviewDetailsPageState createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _score = 1.0;
  String? _currentReviewId;
  bool _noReviewsYet = true;

  @override
  void initState() {
    super.initState();
    _checkForReviews();
  }

  Future<void> _checkForReviews() async {
    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('product')
        .doc(widget.itemId)
        .collection('reviews')
        .limit(1)
        .get();

    setState(() {
      _noReviewsYet = reviewsSnapshot.docs.isEmpty;
    });
  }

  void _navigateToLeaveReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveReviewPage(
          itemId: widget.itemId,
          itemTitle: widget.title,
          imageUrl: widget.imageUrl,
          itemWebUrl: widget.itemWebUrl,
        ),
      ),
    );
  }

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
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final username =
          FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';

      final review = Review(
        itemId: widget.itemId,
        title: _title,
        description: _description,
        score: _score,
        imageUrl: widget.imageUrl,
        itemWebUrl: widget.itemWebUrl,
        userId: userId,
        username: username,
      );

      final productRef =
          FirebaseFirestore.instance.collection('product').doc(widget.itemId);

      DocumentReference reviewRef =
          await productRef.collection('reviews').add(review.toMap());

      _currentReviewId = reviewRef.id;
      Navigator.pop(context);
    }
  }

  Future<void> _deleteReview(String reviewId) async {
    await FirebaseFirestore.instance
        .collection('product')
        .doc(widget.itemId)
        .collection('reviews')
        .doc(reviewId)
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
        child: _noReviewsYet
            ? Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveReviewPage(
                          itemId: widget.itemId,
                          itemTitle: widget.title,
                          imageUrl: widget.imageUrl,
                          itemWebUrl: widget.itemWebUrl,
                        ),
                      ),
                    );
                  },
                  child: Text('Leave the First Review'),
                ),
              )
            : Form(
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
                      decoration:
                          InputDecoration(labelText: 'Review Description'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                      onChanged: (value) =>
                          setState(() => _description = value),
                    ),
                    Slider(
                      value: _score,
                      min: 1.0,
                      max: 5.0,
                      divisions: 8,
                      label: _score.toString(),
                      onChanged: (double value) =>
                          setState(() => _score = value),
                    ),
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: Text('Submit Review'),
                    ),
                    ElevatedButton(
                      onPressed: _currentReviewId != null
                          ? () => _deleteReview(_currentReviewId!)
                          : null,
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
