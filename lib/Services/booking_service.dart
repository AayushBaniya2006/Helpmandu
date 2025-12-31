import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'notification_service.dart';
import 'payment_service.dart';

enum BookingStatus { pending, confirmed, inProgress, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String serviceName;
  final DateTime bookingDate;
  final String bookingTime;
  final String description;
  final BookingStatus status;
  final DateTime createdAt;
  final double? price;
  final String? paymentId;
  final double? rating;
  final String? review;

  Booking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.serviceName,
    required this.bookingDate,
    required this.bookingTime,
    required this.description,
    required this.status,
    required this.createdAt,
    this.price,
    this.paymentId,
    this.rating,
    this.review,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      serviceName: data['serviceName'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      bookingTime: data['bookingTime'] ?? '',
      description: data['description'] ?? '',
      status: BookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      price: data['price']?.toDouble(),
      paymentId: data['paymentId'],
      rating: data['rating']?.toDouble(),
      review: data['review'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'serviceName': serviceName,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'bookingTime': bookingTime,
      'description': description,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'price': price,
      'paymentId': paymentId,
      'rating': rating,
      'review': review,
    };
  }

  Booking copyWith({
    BookingStatus? status,
    double? rating,
    String? review,
    String? paymentId,
  }) {
    return Booking(
      id: id,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      serviceName: serviceName,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      description: description,
      status: status ?? this.status,
      createdAt: createdAt,
      price: price,
      paymentId: paymentId ?? this.paymentId,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();
  final PaymentService _paymentService = PaymentService();
  final Uuid _uuid = const Uuid();

  String? get currentUserId => _auth.currentUser?.uid;
  String? get currentUserName => _auth.currentUser?.displayName;
  String? get currentUserEmail => _auth.currentUser?.email;

  // Create a new booking
  Future<Booking> createBooking({
    required String serviceName,
    required DateTime bookingDate,
    required String bookingTime,
    required String description,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final bookingId = _uuid.v4();
    final price = _paymentService.getServicePrice(serviceName);

    final booking = Booking(
      id: bookingId,
      userId: userId,
      userName: currentUserName ?? 'User',
      userEmail: currentUserEmail ?? '',
      serviceName: serviceName,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      description: description,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
      price: price,
    );

    await _firestore
        .collection('bookings')
        .doc(bookingId)
        .set(booking.toFirestore());

    // Send notification
    await _notificationService.showBookingNotification(
      serviceName: serviceName,
      status: 'pending confirmation',
    );

    return booking;
  }

  // Get user's bookings
  Stream<List<Booking>> getBookings() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList());
  }

  // Get booking by ID
  Future<Booking?> getBooking(String bookingId) async {
    final doc = await _firestore.collection('bookings').doc(bookingId).get();
    if (!doc.exists) return null;
    return Booking.fromFirestore(doc);
  }

  // Update booking status
  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status.name,
    });

    final booking = await getBooking(bookingId);
    if (booking != null) {
      await _notificationService.showBookingNotification(
        serviceName: booking.serviceName,
        status: status.name,
      );
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(
      bookingId: bookingId,
      status: BookingStatus.cancelled,
    );
  }

  // Add rating and review
  Future<void> addRatingAndReview({
    required String bookingId,
    required double rating,
    required String review,
  }) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'rating': rating,
      'review': review,
    });

    // Also add to reviews collection for service
    final booking = await getBooking(bookingId);
    if (booking != null) {
      await _firestore.collection('reviews').add({
        'bookingId': bookingId,
        'userId': currentUserId,
        'userName': currentUserName,
        'serviceName': booking.serviceName,
        'rating': rating,
        'review': review,
        'createdAt': Timestamp.now(),
      });
    }
  }

  // Get upcoming bookings
  Stream<List<Booking>> getUpcomingBookings() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('bookingDate', isGreaterThanOrEqualTo: Timestamp.now())
        .where('status', whereIn: ['pending', 'confirmed'])
        .orderBy('bookingDate')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList());
  }

  // Get past bookings
  Stream<List<Booking>> getPastBookings() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['completed', 'cancelled'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList());
  }

  // Get booking count
  Future<int> getBookingCount() async {
    final userId = currentUserId;
    if (userId == null) return 0;

    final snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .count()
        .get();

    return snapshot.count ?? 0;
  }
}
