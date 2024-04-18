// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qr_app/pages/reviewDetails.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/product_model_ebay.dart';
import '../services/reviews_service.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final ReviewService _reviewService = ReviewService();
  Color _scoreColor(double? score) {
    if (score == null) return Colors.grey;
    if (score < 3) return Colors.deepOrangeAccent;
    if (score < 4) return Colors.yellowAccent;
    return Colors.greenAccent;
  }

  Widget _buildScoreDots(double? score) {
    Color color = _scoreColor(score);
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.circle,
          size: 10,
          color: index < (score?.floor() ?? 0) ? color : Colors.grey,
        );
      }),
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272829),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 32.0, left: 8.0, right: 8.0, bottom: 8.0),
            child: Text(
              "Products Reviews",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
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

                    return GestureDetector(
                        onTap: () async {
                          if (await canLaunchUrl(
                              Uri.parse(product.itemWebUrl!))) {
                            await launchUrl(Uri.parse(product.itemWebUrl!),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Card(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title ?? 'No Title',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Score: ${product.score?.toStringAsFixed(1) ?? 'N/A'} (${product.reviewCount} reviews)',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                ),
                                                SizedBox(width: 8),
                                                _buildScoreDots(product.score),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () => _showReviewDetailsDialog(
                                        context,
                                        product.itemId!,
                                        product.title!,
                                        product.imageUrl!,
                                        product.itemWebUrl!,
                                      ),
                                      child: Text('See all reviews'),
                                    ),
                                    // TextButton(
                                    //   onPressed: () => showLeaveReviewDialog(
                                    //     context,
                                    //     itemId: product.itemId!,
                                    //     itemTitle: product.title!,
                                    //     imageUrl: product.imageUrl!,
                                    //     itemWebUrl: product.itemWebUrl!,
                                    //   ).then((_) {
                                    //     setState(() {});
                                    //   }),
                                    //   child: Text('Add a review'),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showReviewDetailsDialog(BuildContext context, String itemId, String title,
    String imageUrl, String itemWebUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color(0xFF272829),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Product Reviews",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ReviewDetailsContent(
                itemId: itemId,
                title: title,
                imageUrl: imageUrl,
                itemWebUrl: itemWebUrl,
              ),
            ),
          ],
        ),
      );
    },
  );
}
