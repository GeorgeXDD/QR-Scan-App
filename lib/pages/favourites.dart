import 'package:flutter/material.dart';

class FavoriteItem {
  final String imageUrl;
  final String title;
  final String price;

  FavoriteItem(
      {required this.imageUrl, required this.title, required this.price});
}

class FavouritesPage extends StatelessWidget {
  final List<FavoriteItem> favorites = [
    FavoriteItem(
        imageUrl: 'https://via.placeholder.com/150',
        title: 'Item 1',
        price: '\$19.99'),
    FavoriteItem(
        imageUrl: 'https://via.placeholder.com/150',
        title: 'Item 2',
        price: '\$29.99'),
    FavoriteItem(
        imageUrl: 'https://via.placeholder.com/150',
        title: 'Item 3',
        price: '\$39.99'),
    FavoriteItem(
        imageUrl: 'https://via.placeholder.com/150',
        title: 'Item 4',
        price: '\$39.99'),
    FavoriteItem(
        imageUrl: 'https://via.placeholder.com/150',
        title: 'Item 5',
        price: '\$39.99'),
  ];

  Widget _buildFavoriteCard(FavoriteItem item) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.imageUrl, width: 100.0, height: 100.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text('Price: ${item.price}'),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272829),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return _buildFavoriteCard(favorites[index]);
        },
      ),
    );
  }
}
