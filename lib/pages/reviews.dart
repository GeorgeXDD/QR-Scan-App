import 'package:flutter/material.dart';
import 'package:qr_app/pages/leaveReview.dart';
import 'package:qr_app/pages/reviewDetails.dart';

import '../models/product_model_ebay.dart';
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
        title: Text('Products with Reviews',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Color(0xFF272829),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _reviewService.fetchAllProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final products = snapshot.data!;
          if (products.isEmpty) {
            return Center(
              child: Text("No products found.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            product.imageUrl ??
                                'https://via.placeholder.com/150',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title ?? 'No Title',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Score: ${product.score}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReviewDetailsPage(
                                  itemId: product.itemId!,
                                  title: product.title!,
                                  imageUrl: product.imageUrl!,
                                  itemWebUrl: product.itemWebUrl!,
                                ),
                              ));
                            },
                            child: Text('See all reviews'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LeaveReviewPage(
                                  itemId: product.itemId!,
                                  itemTitle: product.title!,
                                  imageUrl: product.imageUrl!,
                                  itemWebUrl: product.itemWebUrl!,
                                ),
                              ));
                            },
                            child: Text('Add a review'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
