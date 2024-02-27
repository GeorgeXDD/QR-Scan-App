import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#p^1#f^0#I^3#r^0#t^H4sIAAAAAAAAAOVYe2wURRi/a3uFBlAElFoeHgsYhNze7t5zl/bw+q6U9to7Wi0Izu7OlqV7u8fOnO2BIWdDqkaDEuIjgRjEBCNGTWNiNEbji4D+wcMHRA0xYlCiNRqDQEgEZ7elXCvh1Uts4v1zmW+++eb3+833zcwOky0uWdxX33d2inNCwa4sky1wOtlJTEmxa8kthQVlLgeT4+DclV2QLeotPFWOQFJLCa0QpQwdQXdPUtORYBsrqLSpCwZAKhJ0kIRIwJIQj65oFDiaEVKmgQ3J0Ch3Q3UFBYI8FGUehANA8vtEhVj1SzETBun3wZAcAAEQlCSRk3jSj1AaNugIAx1XUBzD+T0M5+FCCSYs+IKCn6XDnL+DcrdBE6mGTlxohorYcAV7rJmD9epQAULQxCQIFWmI1sabow3VNU2Jcm9OrMiQDnEMcBqNbFUZMnS3AS0Nrz4Nsr2FeFqSIEKUNzI4w8igQvQSmJuAb0st8orPz8kBmWjtl8KhvEhZa5hJgK+Ow7KoskexXQWoYxVnrqUoUUNcDyU81GoiIRqq3dZfSxpoqqJCs4KqqYw+EI3FqEgdNMxOWGt4WlrjEtA9sdZqDwsgL3FcgPEoigLlUDA0NM1grCGRR81TZeiyakmG3E0GroQEMxytDJejDHFq1pvNqIItPDl+LHNJQZbvsJZ0cA3TeJ1urSpMEhncdvPa+g+PxthUxTSGwxFGd9gCkaJJpVSZGt1pZ+JQ8vSgCmodxinB6+3u7qa7fTQR0MsxDOu9f0VjXFoHk4Cyfa1at/zVaw/wqDYVCZKRSBVwJkWw9JBMJQD0Tiri5xk2zAzpPhJWZLT1X4Yczt6R9ZCv+giIPjEQUvgwqRHo98n5qI/IUIp6LRxQBBlPEphdEKc0IEGPRPIsnYSmKgu+gML5wgr0yEFe8fh5RfGIATnoYRUIGQhFUeLD/58yud5Ej0PJhDhPmZ6nLMehWpU1RS3UmO5eruvreTYDO4N1cn1nV3yDqbaHY3zSL/awsD1acb21cEXyVZpKlEmQ+fMlgFXr+RGh3kAYymOiF5eMFIwZmiplxtcC+0w5BkyciUNNI4YxkYymUg352qnzRO+GNombY53P8+k/OZuuyApZCTu+WFnjEQkAUiptnT60ZCS9BiDXDq9V68S81kY9Jt4qubOOK9aE5CBbVR68bNI2ZRo9LNEmREbaJPdsutm6fSWMLqiT0wybhqZBs40dczUnk2kMRA2Ot7LOQ4KrYJwdtWyI4RnOR8aMiZdkH6Rrx9uWlL+NuGjZDV6ovSM/7iMO+8f2Oj9mep0fFDidTDmzkJ3PzCsuXFlUOLkMqRjSKlBopHbq5JvVhHQXzKSAahZMd/y5+9n6qrKa5ucWb0pkDu/Y75ic87aw60GmdPh1oaSQnZTz1MDMvtzjYm+dOYXzMxwXYsK+oJ/tYOZf7i1i7yiawdw2a2920bn+U/uKX9iyYF7dwbNnljFThp2cTpejqNfp2PbGvoWHlm5ZM6c7s3zzfZO3P56mUR04OO2n739vawktmbFq0+qPLuI5A7/1fHj79spp7935GC39GhaFbxbs/HxRq9i7+8m5/VNfXbu/9ORXDd99KR+hqD3901seqYyBqfM2rgn/de/WSYe/Pr7ni0OzNuzd4az+NvrK6c2P3rNyY2uk1HX8aPuFZMGA8vqFI673J7wz9e5zga4njr18YKLmOLp1588nTiqOh86XiNSx0plLG9vfRKHivlXlE5/5lK9894edd7115umJ4o/TX0P0ts8Wa7N3ZDvUX1pmsdRc9/kstXmrUZ/o399REx/of+n5P/oM/u2y0xebVh848eIn9MCjWRd9eMv2p/5emB5cy38Au/D0OfURAAA=';

  Future<Map<String, dynamic>?> fetchProductDetails(String url) async {
    print(url);
    var link =
        'https://api.ebay.com/buy/browse/v1/item_summary/search?q=857199008597';
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
      if (responseData['itemSummaries'] != null &&
          responseData['itemSummaries'].isNotEmpty) {
        return responseData['itemSummaries'][0];
      } else {
        print('No items found.');
        return null;
      }
    } else {
      print('Failed to load product data: ${response.body}');
      return null;
    }
  }
}
