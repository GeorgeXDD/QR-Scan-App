import 'package:http/http.dart' as http;
import 'dart:convert';

class EbayService {
  final String token =
      'v^1.1#i^1#p^1#I^3#r^0#f^0#t^H4sIAAAAAAAAAOVYW2wUVRje7Q3KNV5pSpssUy+1ZWbPzN46Y3d121LaUOjSXUCJBOdyph06OzPOOUu7YGTbGBINIWilEtRIBGut8uQlEI2IaCABCUSRB0XwwUCABMOLGvEyMy1lWwm3bmIT92Uz//nPf77vO/9/biBTVFy1sWnjrzPdU/J2ZEAmz+2mp4PiosLqWfl5pYUukOXg3pF5IFPQm3+uFvFJ1eDaIDJ0DUFPd1LVEOcYw0TK1DidRwriND4JEYdFLh5d3MIxFOAMU8e6qKuEp7khTMgyL/KMT5bYoMBAKFpW7WrMhB4mBFpgamQhEPBDPigzdjtCKdisIcxrOEwwgPGTwEeCQAKwHM1ygKVAILiS8CyHJlJ0zXKhABFx4HJOXzML642h8ghBE1tBiEhztDHeGm1uWLAkUevNihUZ0SGOeZxCY7/qdQl6lvNqCt54GOR4c/GUKEKECG9keISxQbnoVTB3AN+RmhFpVqaDQlCgoQ8EhJxI2aibSR7fGIdtUSRSdlw5qGEFp2+mqKWGsAaKeORriRWiucFj/y1N8aoiK9AMEwvqok9GYzEishDqZjts1MmlbXGR18hYWwNJ85AVGSYASFmWoRQKhkaGGY41IvK4cep1TVJsyZBniY7roIUZjlcGZCljObVqrWZUxjaeLD+avqqgn11pT+nwHKZwh2bPKkxaMnicz5vrP9obY1MRUhiORhjf4AgUJnjDUCRifKOTiSPJ043CRAfGBuf1dnV1UV0+yhLQywBAe59Y3BIXO2CSJxxfu9Ztf+XmHUjFoSJCqydSOJw2LCzdVqZaALR2IuJnAV0DRnQfCysy3vovQxZn79h6yFV9BGlWhH6JDYRgiIFBXy7qIzKSol4bBxT4NJnkzU6IDZUXISlaeZZKQlOROF9AZnw1MiSlICuTflaWSSEgBUlahhBAKAgiW/P/KZNbTfQ4FE2Ic5TpOcpyHGpUaFNQQy2prkWatoal07A9uFBqau+MP2MqK2pibNIvdNNwRTR8q7VwXfL1qmIpk7DGz5UAdq3nRoQmHWEoTYheXNQNGNNVRUxPrgn2mVKMN3E6DlXVMkyIZNQwmnO1UueI3m0tEnfGOpf703+yN12XFbITdnKxsvsjKwBvKJS9+1CinvTqvHXs8Nq1bplXO6gnxFuxzqyTirVFcpitIg0fNimHMoXWipQJkZ4yrXM21WqfvhJ6J9Ss3QybuqpCczk94WpOJlOYF1Q42co6Bwmu8JNsq6VDgA36gM/PToiX6GykqyfbkpS7hbjgsds8UHvHXu4jLudH97q/AL3uz/LcblALHqQrwLyi/GUF+TNKkYIhpfAyhZR2zbqzmpDqhGmDV8y8e1yX39raVF+6oLW/an0ifey1g64ZWW8LO1aBktHXheJ8enrWUwMou9ZSSM+eM5PxA+viCliaBexKUHGttYC+v+DerzKVLnPvuRf2r/vrjwtfn99Xtu83BGaOOrndha6CXrdr+8eJb4t+39+4eXfV4y+fej20pfHF/kNDl+r2SCWHBqb+PXWrOHB8Ve+ly3f/uPN7s4d45NH3P5j6FH1xzYbz/dAX2XNASMYWRU7MSVw5cSp2dPDU0OLib9b3/RSrPjlw5bs+vfK9CyXh0FbiwLHau+b3bP90esfsXdWlZ6eUlP3y5axYsv+TdYcXShU//Lzl4p77Pjwe3ltxNvFcus94Z/BtxV++xTfQ0Fm9oah909qPXK7ScvfmyjnPPlTeNMudOdw7e+27B5dt875yZm/5tPkNdTuH/jzWInBzp3UemXfyzNzT6ks7E2rZ7v09G4Y8pz9vcymDz2/bxT18tHXa7p6+NysvvDqYOfJGVeDpA8Nz+Q+MR/5c9REAAA==';

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
