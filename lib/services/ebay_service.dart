// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYbWwURRjuXb8sbYGgEW0w1EViAHdv9r5v6R0e/bxK26N38tHEkNm92bJ0b3e7M0t7mJhSBI3+0IKgRI1FxB8i8suP/pCgBms0GhANAQRFRRr5YSSiCSbq7vYo10r46iU28f5c5p133nmeZ953ZnZAX0nZwi1NW/6odJQ6B/tAn9PhYMtBWUnxoumFzqriApDj4Bjsu6+vqL9wpAbDtKxx7QhrqoJRdW9aVjBnG8OUoSucCrGEOQWmEeaIwCWiLcs4NwM4TVeJKqgyVR2rC1N8yAtTCHrYYAiK7lDAtCqXYybVMCV6/cjjSUHIiwEeIN7sx9hAMQUTqJAw5QZuLw38NPAlWZbzAs7tZ7yhQAdVvQLpWFIV04UBVMSGy9lj9Rys14YKMUY6MYNQkVi0IdEWjdXVtyZrXDmxIlkdEgQSA49v1aopVL0Cyga69jTY9uYShiAgjClXZHSG8UG56GUwtwDfljroAcgn+FkIfdATDAbyImWDqqchuTYOyyKlaNF25ZBCJJK5nqKmGvw6JJBsq9UMEaurtv6WG1CWRAnpYap+aXR1NB6nIo1I1TtRg0ovb08IUKHj7XU0C1FIcLt9gBZFEaUC/kB2mtFYWZEnzFOrKinJkgxXt6pkKTIxo4nKeHKUMZ3alDY9KhILT66f57KCQX+HtaSja2iQtYq1qihtylBtN6+v/9hoQnSJNwgaizCxwxYoTEFNk1LUxE47E7PJ04vD1FpCNM7l6unpYXo8jCmgyw0A61rVsiwhrEVpSNm+Vq1b/tL1B9CSTUVA5kgscSSjmVh6zUw1ASidVMQbAmwQZHUfDysy0fovQw5n1/h6yFd9IA/vY4OBoBcEkDfgdeejPiLZFHVZOBAPM3Qa6l2IaDIUEC2YeWakkS6lOI9PdHuCIqJT/pBIe0OiSPO+lJ9mRYQAQjwvhIL/nzK50URPIEFHJE+ZnqcsJ4EGidV5ObDM6HlIUdaF2Azq9Demmjq7Et26tDIYD6W9fC+LVkbDN1oLVyVfK0umMklz/nwJYNV6fkRoUjFBqUnRSwiqhuKqLAmZqbXAHj0VhzrJJJAsm4ZJkYxqWixfO3We6N3UJnFrrPN5Pv0nZ9NVWWErYacWK2s8NgNATWKs04cR1LRLhea1w2XVumleY6OeFG/JvLNOKdYmyVG2Umr0ssnYlBm8XmB0hFVDN+/ZTJt1+0qqXUgxTzOiq7KM9BXspKs5nTYI5GU01co6DwkuwSl21LIBNuALBvxu/6R4CfZBumaqbUn524iLltzkhdo1/uM+UmD/2H7Hh6DfccDpcIAaMJ+dB+4tKXy4qLCiCksEMRIUGSx1KuY3q46YLpTRoKQ7by+48Or2ptqq+rYdCx9NZg6/OFxQkfO2MPgIuGvsdaGskC3PeWoAc670FLMzZle6vcAPfCzrBW5/B5h3pbeIvbPojm+136fzze9XDNMzXxs48sCPdzsbBkDlmJPDUVxQ1O8oCDX/dISUfjJr44ldP6+e3Y52TtsWUXc9X/bEl/fLX9dt/7h0/oJLi17ofvyDvxbrL++ZefL8BtxgnO47eM/QG/uOj3xXvndw/7GzX+zZwzTftu20o2bV/hi+cG6m86vuA3OfbHTGN899dmvnUMvqYb2dObVy05rdF9/687GdypkdA9NmJx5Uust6Rz7d1PfDkvQ3c59u64gfXerfWt+65OC+jf2NywdnNRtzfg2dfKfmQvsvRsNTx3eyc8qPSnTJgvUJqmb/yfZjr8+gz795Yv57I6GLPPjo882H9Ve2TK+s2OtchTbsynx/7tTidy/t/vvMoUOtLR0vCW8/90zp0G9n64e7F30WnlFGqoaSmnt0Lf8BOsH96fURAAA=';

  Future<List<Map<String, dynamic>>?> fetchProductDetails(String url) async {
    var link = 'https://api.ebay.com/buy/browse/v1/item_summary/search?q=$url';
    // var link =
    //     'https://api.ebay.com/buy/browse/v1/item_summary/search?q=$url&filter=conditionIds:{1000}';
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
      final responseData = json.decode(response.body);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(responseData['itemSummaries']);
      return items.isNotEmpty ? items : null;
    } else {
      print('Failed to load product data: ${response.body}');
      return null;
    }
  }
}
