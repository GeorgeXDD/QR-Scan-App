// ignore_for_file: unnecessary_cast, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> fetchAllProducts() async* {
    await for (var snapshot in _db.collection('product').snapshots()) {
      List<Product> productList = [];
      for (var productSnapshot in snapshot.docs) {
        var productData = productSnapshot.data() as Map<String, dynamic>;
        String productId = productSnapshot.id;

        var reviewSnapshot = await _db
            .collection('product')
            .doc(productId)
            .collection('reviews')
            .get();

        double averageScore = 0;
        int reviewCount = reviewSnapshot.docs.length; // Count reviews
        if (reviewCount > 0) {
          double totalScore = reviewSnapshot.docs.fold(0.0,
              (prev, doc) => prev + (doc.data()['score'] as double? ?? 0.0));
          averageScore = totalScore / reviewCount;
        }

        var product = Product.fromFirestoreReview(productData)
          ..score = double.parse(averageScore.toStringAsFixed(1))
          ..reviewCount = reviewCount; // Add review count to Product model
        productList.add(product);
      }
      yield productList;
    }
  }

  Future<double> _calculateAverageReviewScore(String productId) async {
    var reviewSnapshot = await _db
        .collection('product')
        .doc(productId)
        .collection('reviews')
        .get();

    if (reviewSnapshot.docs.isEmpty) {
      return 0.0;
    }

    double totalScore = reviewSnapshot.docs.fold(0.0, (acc, doc) {
      return acc + (doc.data()['score'] as double? ?? 0.0);
    });

    double averageScore = totalScore / reviewSnapshot.docs.length;

    return double.parse(averageScore.toStringAsFixed(1));
  }

  Stream<List<Review>> fetchProductReviews(String productId) {
    return FirebaseFirestore.instance
        .collection('product')
        .doc(productId)
        .collection('reviews')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }
}
