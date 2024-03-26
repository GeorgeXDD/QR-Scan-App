import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';

void showLeaveReviewDialog(BuildContext context,
    {required String itemId,
    required String itemTitle,
    required String imageUrl,
    required String itemWebUrl}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: LeaveReviewPage(
          itemId: itemId,
          itemTitle: itemTitle,
          imageUrl: imageUrl,
          itemWebUrl: itemWebUrl,
        ),
      );
    },
  );
}

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

  Future<String> _fetchUsername(String userId) async {
    String username = 'Anonymous';
    try {
      QuerySnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userProfile')
          .get();

      if (userProfileSnapshot.docs.isNotEmpty) {
        var userProfileDoc = userProfileSnapshot.docs.first;
        Map<String, dynamic> userData =
            userProfileDoc.data() as Map<String, dynamic>;
        return userData['username'] ?? 'Anonymous';
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return username;
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final username = await _fetchUsername(userId);

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                "Let others know your opinion!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "How was the quality of the item?",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Slider(
                value: _score,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                label: _score.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _score = value;
                  });
                },
              ),
              Text(
                'Rating: ${_score.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Give a title to your review!',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _title = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Leave a review description!',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _description = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _submitReview,
                child: Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Maybe later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
