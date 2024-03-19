import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model_ebay.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> fetchAllProducts() {
    return _db.collection('product').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromFirestoreReview(doc.data()))
          .toList();
    });
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
