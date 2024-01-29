// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _searchResults = [];
  bool _isSearching = false;

  final List<String> _allItems = [
    'Item 1',
    'Item 2',
    'Item 3',
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
      });

      // Here you will eventually integrate your API call instead of using _allItems
      List<String> results = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF272829),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _performSearch(value);
                  },
                ),
              ),
              _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        _performSearch('');
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      body: Center(
        child: _isSearching
            ? Text(
                'Searching for ${_controller.text.length > 10 ? _controller.text.substring(0, 10) + '...' : _controller.text}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
            : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index],
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
      ),
      backgroundColor: Color(0xFF272829),
    );
  }
}
