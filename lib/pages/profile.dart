// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors, sort_child_properties_last, deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Future<void> _showSignOutConfirmation(BuildContext context) async {
    bool? confirmSignOut = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 45,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                margin: EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Sign Out",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Are you sure you want to sign out?",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            _signOut(context);
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red[400],
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("No"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[200],
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.red[400],
                  radius: 45,
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmSignOut == true) {
      await _signOut(context);
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

  Future<List<Map<String, dynamic>>> _fetchUserReviews() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    List<Map<String, dynamic>> reviews = [];
    var productSnapshot = await _firestore.collection('product').get();

    for (var productDoc in productSnapshot.docs) {
      var reviewsSnapshot = await productDoc.reference
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .get();

      for (var reviewDoc in reviewsSnapshot.docs) {
        var reviewData = reviewDoc.data();
        reviewData['docId'] = reviewDoc.id;
        reviewData['productId'] = productDoc.id;
        reviews.add(reviewData);
      }
    }

    return reviews;
  }

  Future<void> _deleteReview(String productId, String docId) async {
    try {
      CollectionReference reviews =
          _firestore.collection('product').doc(productId).collection('reviews');

      QuerySnapshot reviewSnapshot = await reviews.get();
      await reviews.doc(docId).delete();

      if (reviewSnapshot.docs.length <= 1) {
        await _firestore.collection('product').doc(productId).delete();
      }

      setState(() {});
    } catch (e) {
      print('Error deleting review or product: $e');
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, String productId, String reviewId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 45,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                margin: EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Delete Review",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Are you sure you want to delete this review?",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Yes, Delete"),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF7f6cb1),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("No, Cancel"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[200],
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Color(0xFF7f6cb1),
                  radius: 45,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirmDelete == true) {
      await _deleteReview(productId, reviewId);
    }
  }

  Future<void> _updateReview(
      String productId, String docId, Map<String, dynamic> updatedData) async {
    await _firestore
        .collection('product')
        .doc(productId)
        .collection('reviews')
        .doc(docId)
        .update(updatedData);
    setState(() {});
  }

  Future<void> _showEditReviewDialog(
      BuildContext context, Map<String, dynamic> review) async {
    TextEditingController titleController =
        TextEditingController(text: review['title']);
    TextEditingController descriptionController =
        TextEditingController(text: review['description'] ?? "");
    double score = review['score'].toDouble();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 45,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                margin: EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ],
                ),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Edit review",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: UnderlineInputBorder(),
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Score:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.purple[700],
                                  inactiveTrackColor: Colors.purple[100],
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 12.0),
                                  thumbColor: Color.fromARGB(255, 184, 62, 206),
                                  overlayColor: Colors.purple.withAlpha(32),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: Colors.purple[700],
                                  inactiveTickMarkColor: Colors.purple[100],
                                  valueIndicatorShape:
                                      PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor:
                                      Color.fromARGB(255, 184, 62, 206),
                                  valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Slider(
                                  value: score,
                                  min: 1.0,
                                  max: 5.0,
                                  divisions: 8,
                                  label: score.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setState(() {
                                      score = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Map<String, dynamic> updatedData = {
                                  'title': titleController.text,
                                  'description': descriptionController.text,
                                  'score': score,
                                };
                                _updateReview(review['productId'],
                                    review['docId'], updatedData);
                                Navigator.of(context).pop();
                              },
                              child: Text("Save"),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF7f6cb1),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Color(0xFF7f6cb1),
                  radius: 45,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserReviewsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUserReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No reviews found.',
                style: TextStyle(color: Colors.white)),
          );
        }

        List<Map<String, dynamic>> reviews = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            var review = reviews[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[850],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.network(
                      review['imageUrl'] ?? 'https://via.placeholder.com/150',
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['title'] ?? 'Review not found',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            review['description'] ?? '',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.white70),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Score: ${review['score'].toString()}',
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _showEditReviewDialog(context, review),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(
                          context, review['productId'], review['docId']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(username,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            Text("$firstName $lastName",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 20)),
                          ],
                        ),
                        CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('lib/assets/logo2.png')),
                      ],
                    ),
                  ),
                  Text(description,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white)),
                          child: Text('Scanned Items: $scannedItemsCount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
                              border: Border.all(color: Colors.white)),
                          child: Text('Favorites: $favoritesCount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => _showSignOutConfirmation(context),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text('Sign Out',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey, thickness: 1),
                  Center(
                    child: Text('My Reviews',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  _buildUserReviewsSection(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
