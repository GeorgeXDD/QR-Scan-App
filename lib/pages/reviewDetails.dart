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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Details'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder<List<Review>>(
        future: _fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: _navigateToLeaveReview,
                child: Text('Leave the First Review'),
              ),
            );
          }

          List<Review> reviews = snapshot.data!;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              Review review = reviews[index];
              return ListTile(
                title: Text(review.title,
                    style:
                        TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                subtitle: Text('Score: ${review.score}',
                    style:
                        TextStyle(color: const Color.fromARGB(179, 0, 0, 0))),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Add logic to edit review if necessary
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToLeaveReview,
        child: Icon(Icons.add),
        tooltip: 'Add Review',
      ),
    );
  }

  Future<List<Review>> _fetchReviews() async {
    List<Review> reviews = [];
    try {
      final QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.itemId)
          .collection('reviews')
          .get();

      reviews = reviewSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Review.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    } catch (e) {
      print("Error fetching reviews: $e");
    }
    return reviews;
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
}
