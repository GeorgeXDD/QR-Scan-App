import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#p^1#I^3#r^0#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTe7QNSSzFRKKbBsE5FycLM3pmd2cdAF5c+6MbSB7u0WCX0zszd7tDZmWHmru0GMKUiifCHP/BHIBWDMSUmNGqMQYmQWIgYYiBC1B+KRjESiRKpiMQ4M13KthJe3cQm7p/NnHvuud/33XPuPTOgf0aZd3vj9j8q3DOLBvtBf5HbTZeDshmli2cXF1WVukCeg3uw/8n+koHin5aZMK3o/Gpk6ppqIk9fWlFN3jHWEBlD5TVoyiavwjQyeSzy8eiqJp6hAK8bGtZETSE8sboaghFYURKhyPk5JHDhgGVVb8ZMaDWEX2C4AAqx/hAHERST1rhpZlBMNTFUsTUfMCwJ/CTgEjTLc2GeC1EgyHQSnnZkmLKmWi4UICIOXN6Za+RhvTNUaJrIwFYQIhKLNsRborG6+ubEMl9erEhOhziGOGNOfKrVJORph0oG3XkZ0/Hm4xlRRKZJ+CJjK0wMykdvgnkA+I7UCEIaBAUJiowEQwWSskEz0hDfGYdtkSUy6bjySMUyzt5NUUsNYQMSce6p2QoRq/PYf20ZqMhJGRk1RP2K6HPR1lYishJpRjdq0Mi21XERqmTr6jqShigsMgwHyGQyiaRgIJhbZixWTuRJ69RqqiTbkpmeZg2vQBZmNFkZNk8Zy6lFbTGiSWzjyfcL3FQwEOy0t3RsDzM4pdq7itKWDB7n8e76j8/G2JCFDEbjESYPOALVEFDXZYmYPOhkYi55+swaIoWxzvt8vb29VK+fsgT0MQDQvrWrmuJiCqUh4fjatW77y3efQMoOFRFZM02Zx1ndwtJnZaoFQO0mImwY0CGQ030irMhk678MeZx9E+uhUPXBBf00ywRCYigYZgWOLUR9RHIp6rNxIAFmyTQ0ehDWFSgiUrTyLJNGhizxfi7J+ENJREqBcJJkw8kkKXBSgKSTCAGEBEEMh/4/ZXKviR5HooFwgTK9QFmOgw0ybQhKsCnT+6yqbgjTWdQdWCk1dvfENxpyR6g1nGaFPhp1RGvutRZuS75WkS1lEtb6hRLArvXCiNComRhJU6IXFzUdtWqKLGan1wb7DakVGjgbR4piGaZEMqrrsUKd1AWid1+HxIOxLuT99J/cTbdlZdoJO71Y2fNNKwDUZcq+fShRS/s0aLUdPrvWLfN6B/WUeMtWzzqtWFskx9jK0lizSTmUKfNFkTKQqWUMq8+mWuzuK6H1INW6zbChKQoy2ukpV3M6ncFQUNB0K+sCJLgMp9lVSwdBOMCB4Hhr9GC8ROciXT/djqTCHcQly++zofZNfLmPuJwfPeA+DgbcR4vcbrAMLKSrwRMziteUFM+qMmWMKBkmKVPuVq13VgNRPSirQ9koetR15cDuxtqq+pY93k2J7OevnXDNyvu2MLgOPDb+daGsmC7P+9QA5t8aKaUfnlfBsMAPOJrlwlyoE1TfGi2hK0vm/Fa+bc0Rtmvfjfe3bN7R0Va+FTGnQMW4k9td6ioZcLvgbFW7Pvf5C8Mb3mzYXvnMI5U/f7PjPL2lQ099eObwgeFr3oPnL9347qljI5tTnQtGdkVOv3PwvcWfLV3iPjP46rD76t+NDZT3amB/aTN9TRz6Yt8uuCdhdDX2H1+gMWe7S18/de7ajujc4bYXlncsWTQaH/no7Mj6+YtO7p2796Wln/iJq3/t3Pjp0eqhV35/uszc9PF5vHXO5S2XqBt93+48UtX16xuJrXv+7Aquk9+qHDlzbDTWJO9auKDioYoTixe+u/+DVC+ZVQ8fftnbgUarXdKPevvuopm/XF/z5blL287+cHn0iDZ08srRQ18PiRHfoabytRe90vfKVxfrU1rAd2He7MdHOe/bp8f28h/6jlsz9REAAA==';

  Future<List<Map<String, dynamic>>?> fetchProductDetails(String url) async {
    print(url);
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
