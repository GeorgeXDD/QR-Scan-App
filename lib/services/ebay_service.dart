// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token = 'token here';

  Future<List<Map<String, dynamic>>?> fetchProductDetails(String url) async {
    var link = 'https://api.ebay.com/buy/browse/v1/item_summary/search?q=$url';
    var endpoint = Uri.parse(link);
    var response = await http.get(
      endpoint,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'X-EBAY-C-MARKETPLACE-ID': 'EBAY_US',
      },
    );

    if (response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body);
        List<Map<String, dynamic>> items =
            List<Map<String, dynamic>>.from(responseData['itemSummaries']);
        return items.isNotEmpty ? items : null;
      } on FormatException catch (e) {
        print('Error decoding JSON response: $e');
        return null;
      } catch (e) {
        print('Error fetching product details: $e');
        return null;
      }
    } else {
      print('Unexpected response format: ${response.body}');
      return null;
    }
  }
}
