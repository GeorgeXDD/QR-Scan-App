import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserProfile({
    required String username,
    required String firstName,
    required String lastName,
    required int scannedItemsCount,
    required String description,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('userProfile').doc(user.uid).set({
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'scannedItemsCount': scannedItemsCount,
        'description': description,
      }, SetOptions(merge: true));
    }
  }
}
