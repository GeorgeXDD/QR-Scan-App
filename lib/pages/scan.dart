// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_app/services/ebay_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/product_model_ebay.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String productId = '0';
  String _scanResult = 'Scan a code';
  List<Product> _productList = [];
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    try {
      final url = await FlutterBarcodeScanner.scanBarcode(
          '#FFFFFF', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      if (url != '-1') {
        setState(() => _scanResult = 'Fetching product information...');

        var ebayService = EbayService();
        var productDataList = await ebayService.fetchProductDetails(url);
        if (productDataList != null && productDataList.isNotEmpty) {
          var favoritesSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .get();
          var favorites = favoritesSnapshot.docs.map((doc) => doc.id).toList();

          var products = productDataList.map((item) {
            var product = Product.fromJson(item);
            product.isFavorited = favorites.contains(product.itemId);
            return product;
          }).toList();

          setState(() => _productList = products);
        } else {
          setState(() => _productList.clear());
        }
      } else {
        setState(() => _scanResult = 'Scan cancelled');
      }
    } catch (e) {
      setState(() => _scanResult = 'Scan failed: $e');
    }
  }

  Widget _buildItemCard(Product product, {bool isFirst = false}) {
    Widget itemImage = Image.network(
      product.imageUrl ?? 'https://via.placeholder.com/150',
      fit: BoxFit.cover,
      width: isFirst ? 150.0 : 100.0,
      height: isFirst ? 150.0 : 100.0,
    );

    return GestureDetector(
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
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemImage,
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
                            fontSize: isFirst ? 18.0 : 15.0,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible,
                        maxLines: isFirst ? 3 : 2,
                      ),
                      Text(
                          'Price: ${product.priceValue ?? "0"} ${product.currency ?? ""}',
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(product.isFavorited
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () async {
                  final docRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('favorites')
                      .doc(product.itemId);

                  if (product.isFavorited) {
                    await docRef.delete();
                  } else {
                    await docRef.set(product.toMap());
                  }
                  setState(() {
                    product.isFavorited = !product.isFavorited;
                  });
                },
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
      backgroundColor: Color(0xFF272829),
      body: _productList.isEmpty
          ? Center(
              child: Text(_scanResult,
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Below are the results of your search",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _productList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _productList.length) {
                        return Center(
                          child: ElevatedButton(
                              onPressed: _startScan,
                              child: Text('Scan a different code')),
                        );
                      }
                      return _buildItemCard(_productList[index],
                          isFirst: index == 0);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
