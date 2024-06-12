// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/pages/leaveReview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/product_model.dart';
import '../services/ebay_service.dart';
import 'reviewDetails.dart';

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
  List<Map<String, dynamic>> searchHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
    _fetchSearchHistory();
    _controller.addListener(_filterSearchHistory);
  }

  @override
  void dispose() {
    _controller.removeListener(_filterSearchHistory);
    _controller.dispose();
    super.dispose();
  }

  void _filterSearchHistory() {
    final query = _controller.text;
    if (query.isNotEmpty) {
      final filteredHistory = searchHistory.where((history) {
        final term = history['term'].toLowerCase();
        return term.contains(query.toLowerCase());
      }).toList();
      setState(() {
        searchHistory = filteredHistory;
      });
    } else {
      _fetchSearchHistory();
    }
  }

  Future<void> _updateSearchHistory(String term) async {
    if (userId == null) return;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('searchHistory')
        .doc(term);

    var data = {'term': term, 'timestamp': FieldValue.serverTimestamp()};

    await docRef.set(data, SetOptions(merge: true));
  }

  void _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    await _updateSearchHistory(query);
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

  Future<void> _fetchSearchHistory() async {
    if (userId == null) return;
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('searchHistory')
        .orderBy('timestamp', descending: true)
        .get();

    var fetchedHistory =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    if (!_controller.text.isNotEmpty) {
      setState(() {
        searchHistory = fetchedHistory;
      });
    }
  }

  Future<void> _removeSearchTerm(String term) async {
    if (userId == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('searchHistory')
        .doc(term)
        .delete();

    _fetchSearchHistory();
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

  void _showReviewDetailsDialog(BuildContext context, String itemId,
      String title, String imageUrl, String itemWebUrl) {
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

  Widget _buildSearchHistoryList() {
    return ListView.separated(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        var item = searchHistory[index];
        return ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(item['term'], style: TextStyle(color: Colors.white)),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => _removeSearchTerm(item['term']),
          ),
          contentPadding: EdgeInsets.only(left: 22.0, right: 18.0),
          onTap: () {
            _controller.text = item['term'];
            _performSearch(item['term']);
          },
        );
      },
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Divider(color: Colors.white24),
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(Product product) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(product.itemWebUrl!))) {
              await launchUrl(Uri.parse(product.itemWebUrl!));
            }
          },
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
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
                          ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => _showReviewDetailsDialog(
                          context,
                          product.itemId!,
                          product.title!,
                          product.imageUrl!,
                          product.itemWebUrl!,
                        ),
                        child: Text('Show reviews'),
                      ),
                      TextButton(
                        onPressed: () => showLeaveReviewDialog(
                          context,
                          itemId: product.itemId!,
                          itemTitle: product.title!,
                          imageUrl: product.imageUrl!,
                          itemWebUrl: product.itemWebUrl!,
                        ).then((_) {
                          setState(() {});
                        }),
                        child: Text('Add a review'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
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
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _performSearch(value);
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  _filterSearchHistory();
                  setState(() => _isSearching = false);
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (!_controller.text.isNotEmpty &&
              !_isSearching &&
              _searchResults.isEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Recent",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
            ),
          Expanded(
            child: _isSearching || _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) =>
                        _buildSearchResultCard(_searchResults[index]),
                  )
                : _buildSearchHistoryList(),
          ),
        ],
      ),
      backgroundColor: Color(0xFF272829),
    );
  }
}
