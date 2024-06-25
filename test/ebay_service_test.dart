import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:qr_app/services/ebay_service.dart';

void main() {
  group('EbayService', () {
    late EbayService ebayService;
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      ebayService = EbayService();
    });

    test('fetchProductDetails returns product details on successful response',
        () async {
      const mockResponseData = {
        "itemSummaries": [
          {
            "title":
                "iOttie Velox Magnetic Wireless Charging Air Vent Car Mount. MagSafe Compatible",
            "price": {"value": "49.95", "currency": "USD"}
          }
        ]
      };

      dioAdapter.onGet(
        'https://api.ebay.com/buy/browse/v1/item_summary/search?q=857199008597',
        (server) => server.reply(200, mockResponseData,
            delay: const Duration(seconds: 1)),
        headers: {
          'Authorization': 'Bearer ${ebayService.token}',
          'Content-Type': 'application/json',
          'X-EBAY-C-MARKETPLACE-ID': 'EBAY_US',
        },
      );

      final result = await ebayService.fetchProductDetails('857199008597');

      expect(result, isNotNull);
      expect(result!.length, 3);
      expect(result[0]['title'],
          'iOttie Velox Magnetic Wireless Charging Air Vent Car Mount. MagSafe Compatible');
      expect(result[0]['price']['value'], '49.95');
    });

    test('fetchProductDetails returns null on error response', () async {
      dioAdapter.onGet(
        'https://api.ebay.com/buy/browse/v1/item_summary/search?q=857199008593',
        (server) => server.reply(400, {}, delay: const Duration(seconds: 1)),
        headers: {
          'Authorization': 'Bearer ${ebayService.token}',
          'Content-Type': 'application/json',
          'X-EBAY-C-MARKETPLACE-ID': 'EBAY_US',
        },
      );

      final result = await ebayService.fetchProductDetails('857199008593');

      expect(result, isNull);
    });
  });
}
