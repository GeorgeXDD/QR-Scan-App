// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

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
  String _scanResult = 'Scan a code';
  String _priceResult = "0.0";
  String _imageResult = '';
  String _webURLResult = '';
  bool _isFavorited = false;

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
        setState(() {
          _scanResult = 'Fetching product information...';
        });

        var ebayService = EbayService();
        var productData = await ebayService.fetchProductDetails(url);
        if (productData != null) {
          Product product = Product.fromJson(productData);
          setState(() {
            _scanResult = product.title;
            _priceResult = 'Price: ${product.priceValue} ${product.currency}';
            _imageResult = product.imageUrl;
            _webURLResult = product.itemWebUrl;
          });
        } else {
          setState(() {
            _scanResult = 'Product not found';
            _priceResult = 'Price: 0';
            _imageResult = 'https://via.placeholder.com/150';
            _webURLResult = '';
          });
        }
      } else {
        setState(() {
          _scanResult = 'Scan cancelled';
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Scan failed: $e';
      });
    }
  }

  Widget _buildItemCard() {
    Widget itemImage = Image.network(
      _imageResult,
      fit: BoxFit.cover,
      width: 100.0,
      height: 100.0,
    );

    return Center(
      child: GestureDetector(
        onTap: () async {
          print('Card tapped!');
          if (_webURLResult.isNotEmpty) {
            final Uri url = Uri.parse(_webURLResult);
            if (await canLaunchUrl(url)) {
              print('URL: $url');
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              print('Could not launch $url');
            }
          }
        },
        child: SizedBox(
          height: 140.0,
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
                            _scanResult,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(_priceResult, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        _isFavorited ? Icons.favorite : Icons.favorite_border),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _isFavorited = !_isFavorited;
                      });
                    },
                  ),
                ],
              ),
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
      body: Center(
        child: _scanResult == 'Scan cancelled' ||
                _scanResult.contains('Scan failed')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_scanResult,
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => _startScan(), child: Text('Retry Scan')),
                ],
              )
            : _buildItemCard(),
      ),
    );
  }
}
