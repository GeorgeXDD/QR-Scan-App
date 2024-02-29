import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return {};

    var userProfileSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('userProfile')
        .doc(userId)
        .get();
    var userProfile = userProfileSnapshot.data() ?? {};

    var favoritesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    int favoritesCount = favoritesSnapshot.docs.length;

    userProfile['favoritesCount'] = favoritesCount;

    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272829),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return Center(
                child: Text('No user profile found',
                    style: TextStyle(color: Colors.white)));
          }

          var userProfile = snapshot.data!;
          String username = userProfile['username'] ?? '@username';
          String firstName = userProfile['firstName'] ?? 'FirstName';
          String lastName = userProfile['lastName'] ?? 'LastName';
          String description =
              userProfile['description'] ?? 'This is a user description.';
          int scannedItemsCount = userProfile['scannedItemsCount'] ?? 0;
          int favoritesCount = userProfile['favoritesCount'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2.0, top: 17.0),
                            child: Text(username,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text("$firstName $lastName",
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 20)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text('Scanned Items: $scannedItemsCount',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text('Favorites: $favoritesCount',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(description,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () => _signOut(context),
                  child: Text('Sign Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
