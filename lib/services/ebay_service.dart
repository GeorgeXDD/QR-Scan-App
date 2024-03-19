import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#I^3#r^0#p^1#f^0#t^H4sIAAAAAAAAAOVYbWwURRi+a6/FWgpSoUUk5NjShIC3N3Nfe7dwR45+y0cP7ihYgnU/ZsvQvd1jd8725OtoCASMmhBrExFtCCY0iqb+QWPEhBowsSEaIz9IRIwJgiRq8AdGY3R3e5RrJXz1Ept4fy7zzjvvPM8z7zszOyBbWrZkf/P+mxX2aUUDWZAtstthOSgrLVk6o7hoXokN5DnYB7KLso7e4qvLdS4pp9j1SE+pio6cPUlZ0VnLGKbSmsKqnI51VuGSSGeJwMaja1azHhqwKU0lqqDKlLOlPkxBhglC5AcCIzGcn4GGVbkVM6GGKQagAPQHkC8A/EhiQka/rqdRi6ITTiFhygM8PhfwumAwAT0sgKzPS/uZQDvlbEOajlXFcKEBFbHgstZYLQ/r3aFyuo40YgShIi3RxnhrtKW+YW1iuTsvViSnQ5xwJK2Pb9WpInK2cXIa3X0a3fJm42lBQLpOuSOjM4wPykZvgXkI+JbUHCMKQYEXpUAoAJgQXxApG1UtyZG74zAtWHRJliuLFIJJ5l6KGmrw25BAcq21RoiWeqf5ty7NyVjCSAtTDSujz0RjMSrShFStEzWqrnXr4wKnuGLr612QQyHB4/EDlyRJSGQCTG6a0Vg5kSfMU6cqIjYl051rVbISGZjReGUg689TxnBqVVq1qERMPPl+vjEFPe3mko6uYZpsVcxVRUlDBqfVvLf+Y6MJ0TCfJmgswsQOSyBjpVMpLFITO61MzCVPjx6mthKSYt3u7u5uuttLGwK6PQBA96Y1q+PCVpTkKMvXrHXTH997gAtbVARkjNQxSzIpA0uPkakGAKWTivhCAAZBTvfxsCITrf8y5HF2j6+HQtWHzxMAIQ+UACf6eBiUClEfkVyKuk0ciOcyriSndSGSkjkBuQQjz9JJpGGR9foljzcoIZcYCEkuX0iSXLxfDLighBBAiOeFUPD/Uyb3m+hxJGiIFCjTC5TlhGnEUONlZnW6e5WibAvBDOoMNInNnV3x7RreGIyFkj6+B6KN0fD91sIdydfJ2FAmYcxfKAHMWi+MCM2qTpA4KXpxQU2hmCpjITO1FtiriTFOI5k4kmXDMCmS0VSqpVA7dYHoPdAm8XCsC3k+/Sdn0x1Z6WbCTi1W5njdCMClMG2ePrSgJt0qZ1w73GatG+YOC/WkeGPjzjqlWBskR9licfSySVuUaf15gdaQrqY1455Nt5q3r4TahRTjNCOaKstIa4OTruZkMk04XkZTrawLkOCYm2JHLWQgYAJeL/BOipdgHaQdU21LKtxG7FjxgBdq9/iP+4jN+sFe+xnQaz9dZLeD5aAW1oCFpcUbHMXT5+mYIBpzEq3jTsX4ZtUQ3YUyKQ5rRY/bbhzra66b19D62pIdicyXR87Zpue9LQxsAXPHXhfKimF53lMDmH+7pwTOrK7w+IAXBqEHQJ+3HdTc7nXAKsfsupsX8M6L9K6+PQv/2lRV9eZ5ftUGUDHmZLeX2By9dlvHi+W/PvbkzMqha08dP/FO9o3hy5V9F/v/3vLVoyP8I46hmgXO0+si1RWHjz9xvRqxR66xwzcO1b5ydmPbvlnvVb3cnni3bsEfTceyTGTR9eGPOwZPzICXP7TtHWnDyZqlm88N9Ox622H//PSO+WemlUfRW5sPOIs97lnd2/20OAcvKsP9n5zkLg3+8Omeyr3bDvW/uqCzofvAVc4/MjLUOFycevr87CvfwtjrP3WU/jj03MkzHzCf2ZYd/X2x/aOilWTF7qHy/UNNlXMPrNp35OujL/124ovFtX/y333zfhpWXaqN7O7LDl64cvAwPnf21AunwkefXXbx+18Ozm35uSszGLgS6ZWrN8wJ7hxdy38AO2NT2PURAAA=';

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
