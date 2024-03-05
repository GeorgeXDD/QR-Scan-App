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

  // Assume this fetches existing review if available
  Future<Review?> _fetchReview() async {
    // Implement fetching logic from Firestore based on widget.itemId
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      // Implement review submission to Firestore
      // Use widget.itemId, _title, _description, _score, widget.imageUrl, widget.itemUrl
    }
  }

  Future<void> _deleteReview() async {
    // Implement review deletion logic from Firestore based on widget.itemId
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
                divisions: 4,
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
