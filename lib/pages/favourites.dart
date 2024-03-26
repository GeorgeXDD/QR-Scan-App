// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/pages/reviewDetails.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product_model_ebay.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Product> _favorites = [];
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    if (userId == null) return;
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    setState(() {
      _favorites = snapshot.docs
          .map((doc) =>
              Product.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _deleteFavorite(String? itemId) async {
    if (userId == null || itemId == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(itemId)
        .delete();
    _fetchFavorites();
  }

  void _showReviewDetailsDialog(BuildContext context, String itemId,
      String title, String imageUrl, String itemWebUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item Reviews",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
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

  Widget _buildFavoriteCard(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(product.itemWebUrl!))) {
            await launchUrl(Uri.parse(product.itemWebUrl!),
                mode: LaunchMode.externalApplication);
          }
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.network(
                  product.imageUrl ?? 'https://via.placeholder.com/150',
                  width: 80.0,
                  height: 80.0,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title ?? 'Product not found',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Price: ${product.priceValue ?? "0"} ${product.currency ?? ""}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      TextButton(
                        onPressed: () => _showReviewDetailsDialog(
                          context,
                          product.itemId!,
                          product.title!,
                          product.imageUrl!,
                          product.itemWebUrl!,
                        ),
                        child: Text(
                          'Show reviews',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () async {
                    await _deleteFavorite(product.itemId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
              "Your Favorites Selection",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _favorites.isEmpty
                ? Center(
                    child: Text(
                      "The page is empty, please add a favorite item first!",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 210, 210, 210),
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      return _buildFavoriteCard(_favorites[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
