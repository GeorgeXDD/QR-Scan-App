import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#r^0#I^3#f^0#p^1#t^H4sIAAAAAAAAAOVYbWwURRi+6xe5lIKKImk0HiuYULJ7s/e5t+kdHv28cPTrjgINpNndmy1L93aX3TmvB0bbGkpMQKPEKtFI05iUH4YfRiX4AbEkEKMEkWiC1B/4SSTYBEHQQOLs9ijXSvjqJTbx/lzmnXfeeZ5n3ndmdkBvmaNqoHHgSoV9TtFQL+gtstvpcuAoK10+r7iostQG8hzsQ71Lekv6i89VG1xK1tg2aGiqYkBnT0pWDNYyhoi0rrAqZ0gGq3ApaLBIYOOR1THWTQFW01WkCqpMOKO1IYJzB7wiRwvQ6/PzjMBgq3IjZkINEV4Y8ItJnhFphmeCST/uN4w0jCoG4hQUItzA7SWBl6SZBGBYEGTdgPIEvB2Esx3qhqQq2IUCRNiCy1pj9Tyst4fKGQbUEQ5ChKOR+nhzJFpb15SoduXFCud0iCMOpY2prRo1CZ3tnJyGt5/GsLzZeFoQoGEQrvDEDFODspEbYO4DviW1XxBpjg/6Gb+P5900LIiU9aqe4tDtcZgWKUmKlisLFSSh7J0UxWrwm6GAcq0mHCJa6zT/WtOcLIkS1ENE3crI+khLCxFugKreBetVsrUtLnAK2dJWS9IcDAputw+QoijCZMAfyE0zESsn8rR5alQlKZmSGc4mFa2EGDOcqkyA9eUpg52alWY9IiITT54fDSYVpDvMJZ1YwzTapJirClNYBqfVvLP+k6MR0iU+jeBkhOkdlkC4qDRNShLTO61MzCVPjxEiNiGksS5XJpOhMh4KC+hyA0C71q2OxYVNMMURlq9Z66a/dOcBpGRREXBmYX8WZTWMpQdnKgagdBFhbxDQDMjpPhVWeLr1X4Y8zq6p9VCo+vCJMEgDD+el8ZYkAK4Q9RHOpajLxAF5LkumOL0bIk3mBEgKOM/SKahLSdbjE90eRoRk0h8USW9QFEnel/STtAghgJDnhSDz/ymTu030OBR0iAqU6QXKchSol2idlwOxdGaVomwO0lnY5W9INnZ1x7fo0lqmJZjy8j00XBsJ3W0t3JJ8jSxhZRJ4/kIJYNZ6YURoVA0EkzOiFxdUDbaosiRkZ9cCe/RkC6ejbBzKMjbMiGRE06KF2qkLRO+eNon7Y13I8+k/OZtuycowE3Z2sTLHGzgAp0mUefpQgppyqRy+drjMWsfmTgv1jHhL+M46q1hjkhNspeTEZZOyKFPGMwKlQ0NN6/ieTTWbt6+E2g0VfJohXZVlqLfTM67mVCqNOF6Gs62sC5DgEjfLjlo6QHu87kDAPzNegnWQds62LalwG3HJinu8ULumftyHbdaP7rePgn77oSK7HVSDpfSTYHFZ8ZqS4rmVhoQgJXEiZUhdCv5m1SHVDbMaJ+lFC2wXh19rrKmsax6s2pbIfvXmMdvcvLeFoY1g0eTrgqOYLs97agCP3ewppec/WuH2Ai9OYgYE3aADPHmzt4ReWPKw0P59kb6XQRtWHfq66d23wlcvnY+Bikknu73UVtJvt0XLzxY/T1asGfnk+DzXgfXdA50v7/7lxdGtY4/sbTh2ZnA1+njDC1dHP0o43quLpLcd7vzhy3bCcerQwtP0zr6j250l36itJx66JB5uHF+262/H/oPygsyzfel1K+Zee/3Hja/sGD998sr4SO87fz24pT34p6pv3bNrfNuiZW3Dozsy52xjWyJLiZO+2vnOOR3bWwfkU5UHLv9xtOfE8P7r4cva4tYnDsa2rx07zlwl2pb/euFEyvnAU8P7jp/pEy++Gvm9K7H5pzmf7Xyp6uTPjrHo04+PZCo/HeT6Pj/YUzN4/tuy1jXvD1X/tuR0w3NvjKz/4O1dVftiB/yxC2f3HDli+27PbvXDa9e/cJfHJ9byH4Xqckr1EQAA';

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
