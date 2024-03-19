import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
  }

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
              child: Text(
                "No products found.",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                margin: EdgeInsets.all(8.0),
                color: Colors.grey[850],
                child: ListTile(
                  leading: Image.network(product.imageUrl ?? '',
                      width: 100, height: 100, fit: BoxFit.cover),
                  title: Text(product.title ?? 'No Title',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReviewDetailsPage(
                        itemId: product.itemId!,
                        title: product.title!,
                        imageUrl: product.imageUrl!,
                        itemWebUrl: product.itemWebUrl!,
                      ),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
