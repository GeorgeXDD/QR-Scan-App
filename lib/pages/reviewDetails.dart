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
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(6.0),
                  color: Color.fromARGB(255, 219, 219, 219),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.title,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF302C34)),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              review.description,
                              style: TextStyle(
                                  fontSize: 15.0, color: Color(0xFF302C34)),
                              maxLines: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Score: ${review.score.toString()}',
                              style: TextStyle(
                                  fontSize: 15.0, color: Color(0xFF302C34)),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "by: ${review.username}",
                                style: TextStyle(
                                    fontSize: 14.0, color: Color(0xFF302C34)),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
