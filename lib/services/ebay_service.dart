import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYe2wURRi/60srLRKoAlXIuQU04O3N7j13w124vmiV9q7c8aoPnNudbZfu7S67c7YnMdZKEB8xQBUJxVCNoAnRBAICxZgUAoRGCYaYYGIUYnz8IT5QLCb+4e72KNdKKNBLbOL9c9mZb775/X7zfTPfDOgsKp6/oW7DYKn9jrzeTtCZZ7dTk0BxUeGCyfl55YU2kGVg7+2c01nQlf/jQh0mJZVdinRVkXXk6EhKss5ajUEipcmsAnVRZ2WYRDqLOTYWbljC0iRgVU3BCqdIhKO+OkgkeNoPPILX4wUAemjaaJWv+owrQYIKJASBoxkKMpCjkd/o1/UUqpd1DGUcJGhAe5yAdtJMnPKyNGBpL+nxMc2EYznSdFGRDRMSECELLmuN1bKw3hgq1HWkYcMJEaoP18Yi4frqmsb4QleWr1BGhxiGOKWP/KpSeORYDqUUuvE0umXNxlIch3SdcIWGZhjplA1fBXMb8C2pA1SAobyIozwezs0InpxIWatoSYhvjMNsEXmnYJmySMYiTo+lqKFGYg3icOar0XBRX+0w/5pSUBIFEWlBoqYyvCocjRKhxUjRWlCt4mxaGuOg7IwurXZSEDEcTXuBUxAExPt9/sw0Q74yIo+ap0qRedGUTHc0KrgSGZjRaGWoLGUMo4gc0cICNvFk2/mHFfQ2m0s6tIYp3Cqbq4qShgwO63Ns/YdHY6yJiRRGwx5Gd1gCBQmoqiJPjO60IjETPB16kGjFWGVdrvb2drLdTRoCumgAKNfKhiUxrhUlIWHZmrlu2otjD3CKFhUOGSN1kcVp1cDSYUSqAUBuIUIeBlABkNF9JKzQ6NZ/NWRxdo3Mh1zlh5/iKUhBd4LmOZ+Pz0V6hDIR6jJhoARMO5NQa0NYlSCHnJwRZqkk0kSedXsF2h0QkJP3MYLTwwiCM+HlfU5KQAgglEhwTOD/kyU3G+cxxGkI5yjQcxTk2F8rUlpC8i9JtT8qy2sYKo1afIv5upa22FpNXBGIMklPooNCK8LBm02F65KvkkRDmbgxf84EMHM9JyLUKTpG/LjoxThFRVFFErn0xFpgt8ZHoYbTMSRJRsO4SIZVtT5XG3WO6N3SJnF7rHN5PP0nR9N1WelmwE4sVuZ43XAAVZE0Tx+SU5IuBRpVhwuaua6Kqy3U4+ItGiXrhGJtkBxiK/JDtSZpUSb1pzlSQ7qS0owym4yYxVdcaUOycZphTZEkpC2nxp3NyWQKw4SEJlpa5yDARTjBjlrKDxjaGEJ7x8WLsw7S1RNtS8rhRlwQurV62jXybh+yWT+qy34UdNk/ybPbwUIwl6oADxTlLyvILynXRYxIEQqkLrbIxpVVQ2QbSqtQ1PKm2S6980ZdVXlNZOv8dfH0mZ6TtpKsp4XeJ8CM4ceF4nxqUtZLA7j/Wk8hdff0UtoDaNq4whoFpLcZVFzrLaDuLSg7u23u3u9tA/0LBjy7Z/VHLr984D0alA4b2e2FtoIuu23R6T+3HqtodeVdObVlR8njDS1/1ZTNi78we+PgD5i88Oouh1j89ZEpTf5vCj//48EpA1M/6t818zn+xL6un/eVlnvQYOulX8G0wGfbtr8YaaxM7P7p5PFDy357dv2dM+bOOVxBXhmYFy3rmXki9trl7ouVG7bzjk3fnT13eMH0U+5VG/uaumq/er/m2F3z3jr0evD3Lxump/YfbD7u3jNZ6PMf7W54U7uvcc4Hb5/8lKjCs7zNyeYtK5Q966b2dU/d3Hv+yIVHKr/te6n7eW7HgbKD4v7EAX/XLmbSu2UDH69/pnTnol8GP2RQdOWpe1556LGdax8+vcm9+dz8L7aWzPi7p+hi61Pn957pWfekPrt/aC3/AVq5jeP0EQAA';

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
