import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#I^3#r^0#f^0#p^1#t^H4sIAAAAAAAAAOVYf2wTVRxft24wYApIhoCE7TZAkbbvru21vayFsh+s7kfLWjaYTnx3fVeOtXfl7pWtMTFlRo1TMcEfaMAwNfxBlBhJMMoPJRvRPwxR8VcISPwD4hJMIERFISa+u5XRTcKvNXGJzSXN+77v+77P5/O+3/feHciUlC57tvHZy2WmKYUDGZApNJno6aC0pPjhe4oK5xcXgBwH00CmOmPuKxqu0WAinuTakJZUZA1V9CbissYZRi+VUmVOgZqkcTJMII3DAhf2tzRzjBVwSVXBiqDEqYpAnZfikeCEHjctsC7BbYeAWOVrMSOKl2JdTqfLDViRhgCyDkT6NS2FArKGoYy9FAMYhwU4LYw7wgCOZsljdXnsnVRFO1I1SZGJixVQPgMuZ4xVc7DeHCrUNKRiEoTyBfwN4aA/UFffGqmx5cTyZXUIY4hT2thWrRJFFe0wnkI3n0YzvLlwShCQplE238gMY4Ny/mtg7gK+ITWi3QDwiOVZhwAZOj9SNihqAuKb49AtUtQiGq4ckrGE07dSlKjBb0ICzrZaSYhAXYX+tyYF45IoIdVL1a/yr/eHQpRvNVLUGGpQLGvawgKULaG2OgsNkUdgGCewiKKIoi7WlZ1mJFZW5HHz1CpyVNIl0ypaFbwKEcxovDIgRxniFJSDql/EOp5cP+aagm5Pp76kI2uYwhtlfVVRgshQYTRvrf/oaIxViU9hNBphfIchkJeCyaQUpcZ3GpmYTZ5ezUttxDjJ2Ww9PT3WHruVCGhjAKBt61qaw8JGlICU4avXuu4v3XqARTKoCCSziD+H00mCpZdkKgEgxyifwwNICmZ1HwvLN976L0MOZ9vYeshXfXhEwQlcdg8QeYYQY/JRH75sitp0HIiHaUsCqt0IJ+NQQBaB5FkqgVQpytmdImN3i8gSZT2ixeERRQvvjLIWWkQIIMTzgsf9/ymT2030MBJUhPOU6XnKcuxqkGiVj7uaUz1NsrzJQ6dRjF0dbYx1hzerUoc75Ek4+F4adfi9t1sLNyRfG5eIMhEyf74E0Gs9PyI0KhpG0QnRCwtKEoWUuCSkJ9cC29VoCKo4HUbxODFMiKQ/mQzka6fOE7072iTujnU+z6f/5Gy6IStNT9jJxUofr5EAMClZ9dPHKigJmwLJtcOm1zoxbzBQT4i3RO6sk4o1ITnCVoqOXDatBmWrtkWwqkhTUiq5Z1uD+u0ronQjmZxmWFXicaS20xOu5kQihSEfR5OtrPOQ4BKcZEct7aJZD+Oyu9gJ8RKMg3TDZNuS8rcRm1fc4YXaNvbl3ldg/Og+0yDoM31aaDKBGrCYrgKVJUVrzUUz5msSRlYJilZNisnknVVF1m6UTkJJLbyv4NI7rzXWzq8Pvr7syUj6651fFMzI+bYw0AXuH/26UFpET8/51AAeuN5TTN87t4xxACfjZgDN0mwnqLrea6bLzXNOc8/0o4XbDh06Zn5891+/Vy7vGnoPlI06mUzFBeY+UwF/poo5ObWnY0Xnka1X9oOmWcNPbTm185FpC0675154Ye9gqPfAuaW/9ItXtMrtm3d0PRR7rrZy22NPP6+82jVvWeDs94FvvWevsi3lh1PnT3PK+r9fnrN7UFpc9W7pgZXfzR66cvGPRfvWLhzmqme2cz98hvYPP9GcaXjzwvqBI8FXdr8xz7G98Zv3T+CZsQ866OO7yk+dLJ9J/1ZVMu2logebIi9+fHTpieM7Du6qdrUdvFp55jLede5S4PN1g5vrj+5x7W1+69yM7bPbhs7vWb4vuWCl7ccP6cGupf5HWxbNWrSqkj8iTD3W39/Bzv7p1+qLnxzu//Mj/5S3M71bh5bAQ601/p+/bFq8JFj21cha/gP6nAna9REAAA==';

  Future<List<Map<String, dynamic>>?> fetchProductDetails(String url) async {
    print(url);
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
