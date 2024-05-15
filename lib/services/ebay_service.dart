import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#I^3#p^1#f^0#r^0#t^H4sIAAAAAAAAAOVYbWwURRju9dpCUwoiCIgQjq38AXZv5m73dm/hjhz9oBVor1xbpIpkb3e2Xbq3u+zu0R4FU4spKDEaAliEaCP8VkxQFJAQfkBI/IEmRBJFNIGgRMVIUBISdXZ7lGslfPUSm3h/LvPOO+88zzPvOzM7oKekdH5fbd+f5Z5xhQM9oKfQ44FloLSkeMFEb+HM4gKQ4+AZ6Hm2p6jX++NiS0ipBr8KWYauWcjXlVI1i3eNESJtarwuWIrFa0IKWbwt8onYyhV8gAK8Yeq2Luoq4aurihCBoIwkmoFJDgTCbEjEVu1OzCY9QoiCIHB0ICAk6QDDsQj3W1Ya1WmWLWg2Hg8CNAkYEtJNgOMZlochiobBVsLXgkxL0TXsQgEi6sLl3bFmDtb7QxUsC5k2DkJE62I1iYZYXVV1fdNif06saFaHhC3YaWt4q1KXkK9FUNPo/tNYrjefSIsisizCHx2cYXhQPnYHzGPAd6UOMxLiGMCIUEASokN5kbJGN1OCfX8cjkWRSNl15ZFmK3bmQYpiNZLrkWhnW/U4RF2Vz/lrTAuqIivIjBDVS2NrYvE4EV2GdLMN1ehk46qEKGhkfFUViVmGxUCAAaQs4xxjQ2x2msFYWZFHzFOpa5LiSGb56nV7KcKY0Uhl6BxlsFOD1mDGZNvBk+MHwR0FAdvqLOngGqbtds1ZVZTCMvjc5oP1Hxpt26aSTNtoKMLIDlegCCEYhiIRIzvdTMwmT5cVIdpt2+D9/s7OTqozSGEB/QEAoP/5lSsSYjtKCYTr69S64688eACpuFREXKTYn7czBsbShTMVA9DaiCgdBpADWd2Hw4qOtP7LkMPZP7we8lUfSZpl2RAMQ1ZGgINMPuojmk1Rv4MDJYUMmRLMDmQbqiAiUsR5lk4hU5H4ICMHgpyMSCkUlkk6LMtkkpFCJJQRAgglk2KY+/+UycMmegKJJrLzlOl5ynKbrVGgmVTZFenO5Zq2PgwzqC20TKpt60hsMJXVXDycopNdEK2ORR62Fu5JvlJVsDJNeP58CeDUen5EqNUtG0mjopcQdQPFdVURM2NrgYOmFBdMO5NAqooNoyIZM4y6fO3UeaL3SJvE47HO5/n0n5xN92RlOQk7tlg54y0cQDAUyjl9KFFP+XUBXzv8Tq1j8zoX9ah4K/jOOqZYY5KDbBVp8LJJuZQpa6NImcjS0ya+Z1MNzu2rSe9AGj7NbFNXVWS2wFFXcyqVtoWkisZaWechwRVhjB21kIVMiGVBMDQqXqJ7kK4ba1tS/jbioiWPeKH2D/+4jxa4P9jrOQV6PScKPR6wGMyDFWBuibe5yDthpqXYiFIEmbKUNg1/s5qI6kAZQ1DMwikFv7+/u7ZyZnXDnvndTZlz+84UTMh5WxhYC2YMvS6UemFZzlMDmHW3pxhOml4eoAEDacAxLAy1goq7vUVwWtHUyNZyKX7kfHXpvOtlU69ufs34LBgE5UNOHk9xQVGvp6B/1tlI7I+pFc0T3n1v2uW/Pi7a2L1tz9XZl/Z+c/zoze5dJ78vrjl77aVj5FuJLz/ZNPHWlL7ptw/EZz9R34+OSNTmyR+cgdMW/b0jsav12mzmV/6c9+QlL7dw9crg7oH+N145+PW4Na8mnl7+9rZ3jjb+PP7Ns1H+eNnWqkU3xIoKiZzzy6a5O7/a0n7xh9NbD13hxnUfPvb5MydOMAebN2U8y2ZcXjP/xoV5Fz0XToWNKzu45kMfPndq8xbfp5HzX1y89VHLsX23t28oDM7Z2bdu6XeVr+9ZMP3MU9tv/rbk9M2y6wtezMTlSbtbYU8lu39/uHHhwn3j02v1J0tefqGlf7L67d7kT2HfgfojOw+rg2v5D6+FoMb1EQAA';

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
