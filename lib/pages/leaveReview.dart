import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';

class LeaveReviewPage extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final String imageUrl;
  final String itemWebUrl;

  const LeaveReviewPage(
      {Key? key,
      required this.itemId,
      required this.itemTitle,
      required this.imageUrl,
      required this.itemWebUrl})
      : super(key: key);

  @override
  State<LeaveReviewPage> createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _score = 1.0;

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

      final productData = {
        'itemId': widget.itemId,
        'title': widget.itemTitle,
        'imageUrl': widget.imageUrl,
        'itemWebUrl': widget.itemWebUrl,
      };

      await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.itemId)
          .set(productData);

      await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.itemId)
          .collection('reviews')
          .add(review.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onChanged: (value) => _title = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                onChanged: (value) => _description = value,
              ),
              Slider(
                value: _score,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                label: _score.toString(),
                onChanged: (value) => setState(() => _score = value),
              ),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
