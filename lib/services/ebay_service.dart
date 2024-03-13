import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#p^1#r^0#f^0#I^3#t^H4sIAAAAAAAAAOVYf2wTVRxfu25k2RDiQAxCqDdAwdz1Xe/W9i60UraV1TFa6NzmIsHr3bvttvtR717ZGgg2S8Q/IBKJkikJDg2RKJABagIRBKPRRBFEiVP/4A+iI6ImEJVJNHp3K6ObhF9r4hL7T/O+7/u+7/P5vO/3vXcPZEvLFm+q33RlqmOKsz8Lsk6HgywHZaUlj9xT7JxdUgTyHBz92flZV2/xhSUGp8gpdjU0UppqQHePIqsGaxuDWFpXWY0zJINVOQUaLOLZRLhxBeslAJvSNaTxmoy5o7VBLEkJXp/oYwDgaVIU/aZVvRazSQtiftpPkjykgZcEAZJnzH7DSMOoaiBORUHMC7w0DiicpJqAnyUDLKAJhgm0Ye5mqBuSppouBMBCNlzWHqvnYb05VM4woI7MIFgoGo4kYuFobd3KpiWevFihnA4JxKG0MbZVownQ3czJaXjzaQzbm02keR4aBuYJjcwwNigbvgbmLuDbUlMkL9KUD/j81b5qn0gWRMqIpiscujkOyyIJuGi7slBFEsrcSlFTjWQn5FGutdIMEa11W3+r0pwsiRLUg1jdsvAT4XgcCy2Hmt4OIxq+anWC51Q8vroWJznI8F5vNcBFUYSC3+fPTTMSKyfyuHlqNFWQLMkM90oNLYMmZjheGZCnjOkUU2N6WEQWnnw/ZlRBqs1a0pE1TKMO1VpVqJgyuO3mrfUfHY2QLiXTCI5GGN9hCxTEuFRKErDxnXYm5pKnxwhiHQilWI+nu7ub6KYIU0CPFwDS09q4IsF3QIXDbF+r1i1/6dYDcMmmwkNzpCGxKJMysfSYmWoCUNuxEM0AMgByuo+FFRpv/Zchj7NnbD0Uqj4E2kcJQpKjICNWi5yvEPURyqWox8IBk1wGVzi9C6KUzPEQ5808SytQlwSWqha9VECEuOBjRJxmRBFPVgs+nBQhBBAmkzwT+P+Uye0megLyOkQFyvQCZTnyRyRST8r+FenuBlXtZMgMbPctF+rbuxJP61JLIM4odLKHhC3h4O3Wwg3J18iSqUyTOX+hBLBqvTAi1GsGgsKE6CV4LQXjmizxmcm1wJQuxDkdZRJQlk3DhEiGU6looXbqAtG7o03i7lgX8nz6T86mG7IyrISdXKys8YYZgEtJhHX6ELymeDTOvHZ4rFo3zWtt1BPiLZl31knF2iQ5wlYSRi6bhE2ZMNbxhA4NLa2b92wiZt2+mrQuqJqnGdI1WYZ6MznhalaUNOKSMpxsZV2ABJe4SXbUkn4SUCTtDdAT4sXbB+naybYlFW4jdj16hxdqz9iP+1CR/SN7HR+AXscxp8MBloAFZBV4sLT4cVdxxWxDQpCQOJEwpHbV/GbVIdEFMylO0p2VRZdfe6m+ZnZdbPvi9U2Z0zs+LqrIe1voXwPuH31dKCsmy/OeGsCc6z0l5LRZU720udwU8JuJTLeBquu9LvI+14zKPT9v2frck7P2tpyLL6ja1khN+x2BqaNODkdJkavXUfT81d1/7/zy2MJ9R744emXD2c39gxe3Rn6Cb1cMtp5YWPVD5pl32Y41A7vfW7b2m9hncw8fnD+4dPjljd8P7z1Rn57et2DmCyd2fiuVd/3x0cAv3PmHj1a65K/e3FXXsf7k2elEX+9vw55F2/9y1L6+eXHvwpPHdpx/J77/4IvO2K/RP8MHtkTa3iKzc8MbShsGtx2+cIVoeMMVvzivZSDrK5v31JGGc61i9NXizy83dzr7lkbKHzuuz9uVnHmGOUXs+e5S8P3he5PlrTsar4oHPiSHBvZPf+hQ94ZXTg3NOX1oEbfv06Gvd0Yqn90445IzC+OXh84cP9nbOffH3YdK94UV15nMJmVPxbopD3wya2Qt/wHqZtXY9REAAA==';

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
