import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Review {
  final String id;
  final String bookingId;
  final String userId;
  final String userName;
  final String serviceName;
  final double rating;
  final String review;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.serviceName,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      serviceName: data['serviceName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      review: data['review'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'userName': userName,
      'serviceName': serviceName,
      'rating': rating,
      'review': review,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ServiceRating {
  final String serviceName;
  final double averageRating;
  final int totalReviews;

  ServiceRating({
    required this.serviceName,
    required this.averageRating,
    required this.totalReviews,
  });
}

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;
  String? get currentUserName => _auth.currentUser?.displayName;

  // Add a review
  Future<void> addReview({
    required String bookingId,
    required String serviceName,
    required double rating,
    required String review,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('reviews').add({
      'bookingId': bookingId,
      'userId': userId,
      'userName': currentUserName ?? 'Anonymous',
      'serviceName': serviceName,
      'rating': rating,
      'review': review,
      'createdAt': Timestamp.now(),
    });

    // Update service rating cache
    await _updateServiceRating(serviceName);
  }

  // Update service average rating
  Future<void> _updateServiceRating(String serviceName) async {
    final reviews = await _firestore
        .collection('reviews')
        .where('serviceName', isEqualTo: serviceName)
        .get();

    if (reviews.docs.isEmpty) return;

    double totalRating = 0;
    for (var doc in reviews.docs) {
      totalRating += (doc.data()['rating'] ?? 0).toDouble();
    }

    final averageRating = totalRating / reviews.docs.length;

    await _firestore.collection('serviceRatings').doc(serviceName).set({
      'serviceName': serviceName,
      'averageRating': averageRating,
      'totalReviews': reviews.docs.length,
      'updatedAt': Timestamp.now(),
    });
  }

  // Get reviews for a service
  Stream<List<Review>> getServiceReviews(String serviceName) {
    return _firestore
        .collection('reviews')
        .where('serviceName', isEqualTo: serviceName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  // Get service rating
  Future<ServiceRating?> getServiceRating(String serviceName) async {
    final doc =
        await _firestore.collection('serviceRatings').doc(serviceName).get();

    if (!doc.exists) {
      return ServiceRating(
        serviceName: serviceName,
        averageRating: 0,
        totalReviews: 0,
      );
    }

    final data = doc.data()!;
    return ServiceRating(
      serviceName: serviceName,
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
    );
  }

  // Get all service ratings
  Stream<List<ServiceRating>> getAllServiceRatings() {
    return _firestore.collection('serviceRatings').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ServiceRating(
                  serviceName: doc.data()['serviceName'] ?? '',
                  averageRating: (doc.data()['averageRating'] ?? 0).toDouble(),
                  totalReviews: doc.data()['totalReviews'] ?? 0,
                ))
            .toList());
  }

  // Get user's reviews
  Stream<List<Review>> getUserReviews() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  // Check if user has reviewed a booking
  Future<bool> hasUserReviewedBooking(String bookingId) async {
    final userId = currentUserId;
    if (userId == null) return false;

    final reviews = await _firestore
        .collection('reviews')
        .where('bookingId', isEqualTo: bookingId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    return reviews.docs.isNotEmpty;
  }

  // Delete review
  Future<void> deleteReview(String reviewId) async {
    final review =
        await _firestore.collection('reviews').doc(reviewId).get();
    final serviceName = review.data()?['serviceName'];

    await _firestore.collection('reviews').doc(reviewId).delete();

    if (serviceName != null) {
      await _updateServiceRating(serviceName);
    }
  }

  // Get top rated services
  Future<List<ServiceRating>> getTopRatedServices({int limit = 5}) async {
    final snapshot = await _firestore
        .collection('serviceRatings')
        .orderBy('averageRating', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ServiceRating(
              serviceName: doc.data()['serviceName'] ?? '',
              averageRating: (doc.data()['averageRating'] ?? 0).toDouble(),
              totalReviews: doc.data()['totalReviews'] ?? 0,
            ))
        .toList();
  }
}
