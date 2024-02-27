import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#r^0#p^1#f^0#I^3#t^H4sIAAAAAAAAAOVYa2wUVRTebbeF8mhjQGsaxWUqhKAze2f2NTvpLlla+qClXbrLohDFedxpp52dGWZmaTfGuK4R+FGCKDSxGtNAg8SEoKBBBG0CJEoUtGok8jAY/YENmKgpRhLFmelStpXw6iY2cf9s7rnnnvt93z3n3jsXpItLFm+s3/jHbPu0gv40SBfY7fhMUFJc9FhpYUFFkQ3kONj704+mHZnCi1UanRAVqhVqiixp0NmdECWNsoxBJKlKlExrgkZJdAJqlM5S0fCKJorAAKWosi6zsog4G2qCCEeSvIf2unme8eE09BtW6XrMmBxECBxnPYAMuAEkPIzfY/RrWhI2SJpOS7rRDwgPCgiU8MdwN+UhKRzHAl7vGsQZh6omyJLhggEkZMGlrLFqDtZbQ6U1Daq6EQQJNYRroy3hhpplzbEqV06sUFaHqE7rSW18q1rmoDNOi0l462k0y5uKJlkWahriCo3OMD4oFb4O5h7gW1J7SZb0cW7cDz0QEiyTFylrZTVB67fGYVoEDuUtVwpKuqCnbqeooQbTAVk922o2QjTUOM2/lUlaFHgBqkFk2dLwk+FIBAnVQVltg7UyurI1ytISGmmtQY1sCrAE4QUoz/OQ8/v82WlGY2VFnjBPtSxxgimZ5myW9aXQwAwnKuPOUcZwapFa1DCvm3hy/bxjCuJrzCUdXcOk3i6ZqwoThgxOq3l7/cdG67oqMEkdjkWY2GEJFERoRRE4ZGKnlYnZ5OnWgki7riuUy9XV1YV1uTFDQBcBAO56YkVTlG2HCRqxfM1aN/2F2w9ABYsKC42RmkDpKcXA0m1kqgFAakNCngDASZDVfTys0ETrvww5nF3j6yFf9eHDfV5AEn7aS/oY3JuXrSaUTVGXiQMydApN0Gon1BWRZiHKGnmWTEBV4Ci3lyfcJA9RzhfgUU+A51HGy/lQnIcQQMgwbID8/5TJnSZ6FLIq1POU6XnKct1fK+AqI/qbkl2NktQRwFOwzVfH1bd1RterwmoyEkh4mG4crg4H77QWbkq+WhQMZWLG/PkSwKz1/IhQL2s65CZFL8rKCozIosCmptYCu1UuQqt6KgpF0TBMimRYURrytVPnid5dbRL3xjqf59N/cjbdlJVmJuzUYmWO14wAtCJg5umDsXLCJdPGtcNl1rphXmehnhRvwbizTinWBslRtgI3etnELMqYtoHFVKjJSdW4Z2Mt5u0rJndCyTjNdFUWRajG8UlXcyKR1GlGhFOtrPOQ4AI9xY5a3A8CwIP7ApNbNtY6SNdNtS0pfxuxY8ldXqhd4z/uQzbrh2fsR0HG/nGB3Q6qwAK8EswvLlzlKJxVoQk6xASaxzShTTK+WVWIdcKUQgtqwRzbbzt31FdXLGvpXfxsLPXl65/YZuW8LfQ/BR4ce10oKcRn5jw1gIdu9BThZeWzCQ8gCD/u9pA4vgZU3uh14A845r7/42B5+Qt/+Tb/xG/duZ+cGxlK9YHZY052e5HNkbHblvfuHehknj72A8J8uGDeYOUj6KfHnx/q65i+6Wqv91jtruO/tiwv6H4ms/jgtfiVi9sjR+pOPDdSOXCpbV9674XNr2zq3lad6L9kP/Ne1+G3Bw59MFzFle35fdG5ogv+v0d+mf75d/vLrnUseQMrffjI2Z/XznjzwDdbF55pGj5aWtLT8dE1pdoDVpWdt/W0nrxysqd0x8xTw7HTC15c9PV05txLfYd337/x/LR445YZRPwrShjc9/Lu8Nn5pxFs3p/t5VXp1xqbRw7smqO+tYF+52D/5cGhbUMntrhOVXxR+NnVg46+xqPF8W83DCRidRmHSvd13Hfk3Z6R9Zn+wbXbF37/qnpo34zHheE9l0fX8h+PXEG79REAAA==';

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
      // Return the whole list of items
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(responseData['itemSummaries']);
      return items.isNotEmpty ? items : null;
    } else {
      print('Failed to load product data: ${response.body}');
      return null;
    }
  }
}
