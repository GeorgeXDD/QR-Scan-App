import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:html/parser.dart';
import 'package:qr_app/models/product_model.dart';

void main() {
  group('scrapeEMAG', () {
    test('returns product list on successful response', () async {
      const mockResponseData = '''
        <div class="card-item js-product-data" data-product-id="12345">
          <a class="card-v2-title" href="https://www.emag.ro/product1">Product 1</a>
          <p class="product-new-price">1,234.56 RON</p>
          <div class="img-component">
            <img src="https://www.emag.ro/image1.jpg" />
          </div>
        </div>
      ''';

      final mockClient = MockClient((request) async {
        return http.Response(mockResponseData, 200, headers: {
          'Content-Type': 'text/html; charset=utf-8',
        });
      });

      var products = await scrapeEMAGWithClient('test', mockClient);

      expect(products, isNotEmpty);
      expect(products.length, 1);
      expect(products[0].title, 'Product 1');
      expect(products[0].priceValue, '270.24');
      expect(products[0].currency, 'USD');
    });

    test('returns empty list on error response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      var products = await scrapeEMAGWithClient('test', mockClient);

      expect(products, isEmpty);
    });
  });
}

Future<List<Product>> scrapeEMAGWithClient(
    String searchKeyword, http.Client client) async {
  List<Product> products = [];
  var url = 'https://www.emag.ro/search/$searchKeyword';
  var headers = {
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
  };

  try {
    var response = await client.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var productElements =
          document.querySelectorAll('div.card-item.js-product-data');

      for (var element in productElements) {
        var titleElement = element.querySelector('a.card-v2-title');
        var priceElement = element.querySelector('p.product-new-price');
        var imageElement = element.querySelector('div.img-component img');
        var priceText = priceElement?.text.trim().replaceAll(RegExp(r'\D'), '');

        String? price = priceText;

        if (price!.isNotEmpty) {
          try {
            price = price.substring(0, price.length - 2) +
                '.' +
                price.substring(price.length - 2);

            double priceValue = double.parse(price);

            int roundedPrice = priceValue.round();

            double conversionRate = 4.57;

            double convertedPriceValue = roundedPrice / conversionRate;

            price = convertedPriceValue.toStringAsFixed(2);
          } catch (e) {
            print("Error parsing price: $e");
          }
        }
        String? currency = "USD";

        products.add(Product(
          itemId: element.attributes['data-product-id'],
          title: titleElement?.text.trim(),
          imageUrl: imageElement?.attributes['src'],
          itemWebUrl: titleElement?.attributes['href'],
          priceValue: price,
          currency: currency,
        ));
      }
    } else {
      print('Failed to load page');
    }
  } catch (e) {
    print('Error: $e');
  }

  return products;
}
