// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_app/pages/header_widget.dart';
import 'package:qr_app/services/ebay_service.dart';
import 'package:qr_app/services/scraper_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/product_model.dart';
import 'reviewDetails.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String productId = '0';
  String _scanResult = 'Scan a code';
  List<Product> _productList = [];
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  bool isScanning = false;
  bool ebayChecked = true;
  bool emagChecked = false;
  bool altexChecked = false;

  Future<void> _startScan() async {
    try {
      final url = await FlutterBarcodeScanner.scanBarcode(
          '#FFFFFF', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      if (url != '-1') {
        setState(() {
          _scanResult = 'Fetching product information...';
          isScanning = true;
        });

        var ebayService = EbayService();
        var productDataList = await ebayService.fetchProductDetails(url);

        await _incrementScannedItemsCount();

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
            product.source = 'eBay';
            return product;
          }).toList();

          if (emagChecked && products.isNotEmpty) {
            var emagResults = await scrapeEMAG(products.first.title!);
            emagResults.forEach((product) {
              product.source = 'eMAG';
            });
            products.addAll(emagResults);
          }

          if (altexChecked && products.isNotEmpty) {
            var altexResults = await scrapeEMAG(products.first.title!);
            altexResults.forEach((product) {
              product.source = 'Altex';
            });
            products.addAll(altexResults);
          }

          products.sort((a, b) {
            if (a.source != b.source) {
              return a.source == 'eBay' ? -1 : 1;
            }
            return a.priceValue!.compareTo(b.priceValue!);
          });

          setState(() => _productList = products);
        } else {
          setState(() => _productList.clear());
          isScanning = false;
        }
        setState(() => isScanning = false);
      } else {
        setState(() => _scanResult = 'Scan cancelled');
      }
    } catch (e) {
      setState(() => _scanResult = 'Scan failed: $e');
      isScanning = false;
    }
  }

  Future<void> _incrementScannedItemsCount() async {
    if (userId != null) {
      var userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userProfile')
          .doc(userId);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        var userProfileSnapshot = await transaction.get(userDoc);
        if (userProfileSnapshot.exists) {
          int currentCount =
              userProfileSnapshot.data()?['scannedItemsCount'] ?? 0;
          transaction.update(userDoc, {'scannedItemsCount': currentCount + 1});
        }
      });
    }
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

  Widget _buildItemCard(Product product, {bool isFirst = false}) {
    Widget itemImage = Image.network(
      product.imageUrl ?? 'https://via.placeholder.com/150',
      width: isFirst ? 200.0 : 100.0,
      height: isFirst ? 200.0 : 100.0,
    );

    return GestureDetector(
      onTap: () async {
        if (product.itemWebUrl?.isNotEmpty ?? false) {
          final Uri url = Uri.parse(product.itemWebUrl!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Card(
        child: isFirst
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: itemImage,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
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
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      product.title ?? 'Product not found',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      maxLines: 3,
                    ),
                  ),
                  Text(
                    'Price: ${product.priceValue ?? "0"} ${product.currency ?? ""}',
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
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
                  SizedBox(height: 20),
                ],
              )
            : Padding(
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
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                            ),
                            Text(
                              'Price: ${product.priceValue ?? "0"} ${product.currency ?? ""}',
                              overflow: TextOverflow.ellipsis,
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
      body: Column(
        children: [
          HeaderWidget(),
          if (!isScanning && _productList.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _startScan,
                      child: Text('Start scanning'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: ebayChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              ebayChecked = value!;
                            });
                          },
                        ),
                        Text("eBay", style: TextStyle(color: Colors.white)),
                        Checkbox(
                          value: emagChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              emagChecked = value!;
                            });
                          },
                        ),
                        Text("eMAG", style: TextStyle(color: Colors.white)),
                        Checkbox(
                          value: altexChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              altexChecked = value!;
                            });
                          },
                        ),
                        Text("Altex", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (isScanning)
            Padding(
              padding: const EdgeInsets.only(
                  top: 232.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                'Fetching product data...',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          if (_productList.isNotEmpty && !isScanning)
            Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Text("Scan Results",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          if (_productList.isNotEmpty && !isScanning)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _startScan,
                        child: Text('Scan again'),
                      ),
                    ),
                    Checkbox(
                      value: ebayChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          ebayChecked = value!;
                        });
                      },
                    ),
                    Text("eBay", style: TextStyle(color: Colors.white)),
                    Checkbox(
                      value: emagChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          emagChecked = value!;
                        });
                      },
                    ),
                    Text("eMAG", style: TextStyle(color: Colors.white)),
                    Checkbox(
                      value: altexChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          altexChecked = value!;
                        });
                      },
                    ),
                    Text("Altex", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          if (_productList.isNotEmpty && !isScanning)
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
