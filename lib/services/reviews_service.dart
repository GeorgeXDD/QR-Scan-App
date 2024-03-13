import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Review>> fetchReviews() {
    return _db.collection('reviews').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }
}
