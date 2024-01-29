// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _scanResult = 'Scan a code';
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#FFFFFF',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (!mounted) return;
      setState(() {
        _scanResult = result != '-1' ? result : 'Scan cancelled';
        _isFavorited = false;
      });
    } catch (e) {
      setState(() {
        _scanResult = 'Scan failed: $e';
      });
    }
  }

  Widget _buildItemCard() {
    Widget itemImage = Image.network(
      'https://via.placeholder.com/150',
      fit: BoxFit.cover,
      width: 100.0,
      height: 100.0,
    );

    return Center(
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
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text('Price: \$XX.XX'),
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
