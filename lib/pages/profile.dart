import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate back to the login page or any other page as needed
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // Handle sign-out errors here
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _signOut(context);
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
