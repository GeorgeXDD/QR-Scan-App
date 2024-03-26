import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_app/pages/leaveReview.dart';
import '../models/review_model.dart';

class ReviewDetailsContent extends StatelessWidget {
  final String itemId;
  final String title;
  final String imageUrl;
  final String itemWebUrl;

  const ReviewDetailsContent({
    Key? key,
    required this.itemId,
    required this.title,
    required this.imageUrl,
    required this.itemWebUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: _fetchReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 400,
            child: Center(
              child: ElevatedButton(
                onPressed: () => _navigateToLeaveReview(context),
                child: Text('Leave the First Review'),
              ),
            ),
          );
        }

        List<Review> reviews = snapshot.data!;

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              Review review = reviews[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.title,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "By: ${review.username}",
                          style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          review.description,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[800]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Score: ${review.score}',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey, thickness: 1),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Review>> _fetchReviews() async {
    List<Review> reviews = [];
    try {
      final QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('product')
          .doc(itemId)
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

  void _navigateToLeaveReview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveReviewPage(
          itemId: itemId,
          itemTitle: title,
          imageUrl: imageUrl,
          itemWebUrl: itemWebUrl,
        ),
      ),
    );
  }
}

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
      body: ReviewDetailsContent(
        itemId: widget.itemId,
        title: widget.title,
        imageUrl: widget.imageUrl,
        itemWebUrl: widget.itemWebUrl,
      ),
    );
  }
}
