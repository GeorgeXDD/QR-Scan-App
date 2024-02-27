import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/product_model_ebay.dart';
import '../services/ebay_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final EbayService _ebayService = EbayService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  Set<String> _favoritesIds = {};
  List<Product> _searchResults = [];
  bool _isSearching = false;

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
      _favoritesIds = Set.from(snapshot.docs.map((doc) => doc.id));
    });
  }

  void _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    final items = await _ebayService.fetchProductDetails(query);
    if (items != null) {
      setState(() {
        _searchResults = items.map((item) {
          var product = Product.fromJson(item);
          product.isFavorited = _favoritesIds.contains(product.itemId);
          return product;
        }).toList();
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
    }
  }

  Future<void> _toggleFavorite(Product product) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.itemId);

    if (product.isFavorited) {
      await docRef.delete();
      _favoritesIds.remove(product.itemId);
    } else {
      await docRef.set(product.toMap());
      _favoritesIds.add(product.itemId!);
    }
    setState(() {
      product.isFavorited = !product.isFavorited;
    });
  }

  Widget _buildSearchResultCard(Product product) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(product.itemWebUrl!))) {
          await launchUrl(Uri.parse(product.itemWebUrl!));
        }
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.imageUrl ?? 'https://via.placeholder.com/150',
                width: 100.0,
                height: 100.0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          'Price: ${product.priceValue ?? "0"} ${product.currency ?? ""}'),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                    product.isFavorited
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red),
                onPressed: () => _toggleFavorite(product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF272829),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) => _performSearch(value),
                ),
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  _performSearch('');
                },
              ),
            ],
          ),
        ),
      ),
      body: _isSearching
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) =>
                  _buildSearchResultCard(_searchResults[index]),
            ),
      backgroundColor: Color(0xFF272829),
    );
  }
}
