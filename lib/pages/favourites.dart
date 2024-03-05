import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Widget _buildFavoriteCard(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () async {
          if (product.itemWebUrl?.isNotEmpty ?? false) {
            final Uri url = Uri.parse(product.itemWebUrl!);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              print('Could not launch $url');
            }
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
                  fit: BoxFit.cover,
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
                      SizedBox(height: 4),
                      Text(
                        'Price: ${product.priceValue ?? "0"} ${product.currency ?? ""}',
                        style: TextStyle(fontSize: 16.0),
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
      appBar: AppBar(
        title: Text(
          'Your Favorites Selection',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF272829),
      ),
      body: _favorites.isEmpty
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
    );
  }
}
