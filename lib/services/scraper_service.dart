import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import '../models/product_model_ebay.dart';

Future<List<Product>> scrapeEMAG(String searchKeyword) async {
  List<Product> products = [];
  var url = 'https://www.emag.ro/search/$searchKeyword';
  var headers = {
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
  };

  try {
    var response = await http.get(Uri.parse(url), headers: headers);
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
        print('Price = ' + price!);

        if (price.isNotEmpty) {
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

  for (var product in products) {
    print('ItemID: ${product.itemId}');
    print('Title: ${product.title}');
    print('Price: ${product.priceValue} ${product.currency}');
    print('Link: ${product.itemWebUrl}');
    print('Image URL: ${product.imageUrl}');
    print('-----------------------');
  }

  return products;
}

Future<List<Product>> scrapeALTEX(String searchKeyword) async {
  List<Product> products = [];
  var url = 'https://altex.ro/cauta/?q=$searchKeyword';
  var headers = {
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
  };

  try {
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var productElements = document.querySelectorAll('div.Products-item');

      for (var element in productElements) {
        var titleElement = element.querySelector('a.title');
        var priceElement = element.querySelector('span.Price-int');
        var imageElement = element.querySelector('img');
        var priceText = priceElement?.text.trim().replaceAll(RegExp(r'\D'), '');

        String? price = priceText;
        if (price != null && price.isNotEmpty) {
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
          itemId: "",
          title: titleElement?.text.trim() ?? "No title",
          imageUrl: imageElement?.attributes['src'] ?? "No image URL",
          itemWebUrl: titleElement?.attributes['href'] ?? "No URL",
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

  for (var product in products) {
    print('Title: ${product.title}');
    print('Price: ${product.priceValue} ${product.currency}');
    print('Link: ${product.itemWebUrl}');
    print('Image URL: ${product.imageUrl}');
    print('-----------------------');
  }

  return products;
}