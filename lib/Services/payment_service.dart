import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'app_config.dart';
import 'booking_service.dart';

enum PaymentMethod { esewa, khalti, cashOnDelivery }

enum PaymentStatus { pending, completed, failed, refunded }

class Payment {
  final String id;
  final String bookingId;
  final String userId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime createdAt;
  final String? transactionId;

  Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.transactionId,
  });

  factory Payment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Payment(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      method: PaymentMethod.values.firstWhere(
        (e) => e.name == data['method'],
        orElse: () => PaymentMethod.cashOnDelivery,
      ),
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      transactionId: data['transactionId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'transactionId': transactionId,
    };
  }
}

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();
  final AppConfig _appConfig = AppConfig();

  // Store pending payment ID for callback handling
  String? _pendingPaymentId;
  String? get pendingPaymentId => _pendingPaymentId;

  String? get currentUserId => _auth.currentUser?.uid;

  // Initialize payment
  Future<Payment> initializePayment({
    required String bookingId,
    required double amount,
    required PaymentMethod method,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final paymentId = _uuid.v4();
    final payment = Payment(
      id: paymentId,
      bookingId: bookingId,
      userId: userId,
      amount: amount,
      method: method,
      status: PaymentStatus.pending,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('payments')
        .doc(paymentId)
        .set(payment.toFirestore());

    // Store for callback handling
    _pendingPaymentId = paymentId;

    return payment;
  }

  // Process eSewa payment
  Future<bool> processEsewaPayment({
    required String paymentId,
    required double amount,
    required String productName,
  }) async {
    try {
      final config = _appConfig.payment;

      final params = {
        'amt': amount.toString(),
        'psc': '0', // Service charge
        'pdc': '0', // Delivery charge
        'txAmt': '0', // Tax amount
        'tAmt': amount.toString(), // Total amount
        'pid': paymentId, // Product ID
        'scd': config.esewaMerchantId, // Merchant code
        'su': PaymentConfig.successCallback, // Success URL
        'fu': PaymentConfig.failureCallback, // Failure URL
      };

      final uri = Uri.parse(config.esewaUrl).replace(queryParameters: params);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('eSewa payment error: $e');
      return false;
    }
  }

  // Process Khalti payment
  Future<bool> processKhaltiPayment({
    required String paymentId,
    required double amount,
    required String productName,
  }) async {
    try {
      final config = _appConfig.payment;

      final params = {
        'public_key': config.khaltiPublicKey,
        'product_identity': paymentId,
        'product_name': productName,
        'amount': (amount * 100).toInt().toString(), // Amount in paisa
        'product_url': 'https://helpmandu.com',
        'return_url': PaymentConfig.successCallback,
      };

      final uri = Uri.parse(config.khaltiUrl).replace(queryParameters: params);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Khalti payment error: $e');
      return false;
    }
  }

  /// Handle payment callback from deep link
  Future<PaymentCallbackResult> handlePaymentCallback(Uri uri) async {
    final path = uri.path;
    final queryParams = uri.queryParameters;

    // Get the payment ID from stored pending payment or query params
    final paymentId = queryParams['pid'] ??
                      queryParams['product_identity'] ??
                      _pendingPaymentId;

    if (paymentId == null) {
      return PaymentCallbackResult(
        success: false,
        message: 'Payment ID not found',
      );
    }

    try {
      if (path.contains('success')) {
        // Extract transaction ID if available
        final transactionId = queryParams['refId'] ??
                              queryParams['txnId'] ??
                              queryParams['idx'];

        // Update payment status to completed
        await updatePaymentStatus(
          paymentId: paymentId,
          status: PaymentStatus.completed,
          transactionId: transactionId,
        );

        // Update booking payment ID
        final payment = await getPayment(paymentId);
        if (payment != null) {
          await _firestore.collection('bookings').doc(payment.bookingId).update({
            'paymentId': paymentId,
          });
        }

        _pendingPaymentId = null;

        return PaymentCallbackResult(
          success: true,
          message: 'Payment successful',
          paymentId: paymentId,
          transactionId: transactionId,
        );
      } else if (path.contains('failure')) {
        // Update payment status to failed
        await updatePaymentStatus(
          paymentId: paymentId,
          status: PaymentStatus.failed,
        );

        _pendingPaymentId = null;

        return PaymentCallbackResult(
          success: false,
          message: 'Payment failed or cancelled',
          paymentId: paymentId,
        );
      }

      return PaymentCallbackResult(
        success: false,
        message: 'Unknown payment callback',
      );
    } catch (e) {
      return PaymentCallbackResult(
        success: false,
        message: 'Error processing payment: $e',
      );
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus status,
    String? transactionId,
  }) async {
    final updateData = <String, dynamic>{
      'status': status.name,
    };

    if (transactionId != null) {
      updateData['transactionId'] = transactionId;
    }

    await _firestore.collection('payments').doc(paymentId).update(updateData);
  }

  // Get payment by ID
  Future<Payment?> getPayment(String paymentId) async {
    final doc = await _firestore.collection('payments').doc(paymentId).get();
    if (!doc.exists) return null;
    return Payment.fromFirestore(doc);
  }

  // Get user's payment history
  Stream<List<Payment>> getPaymentHistory() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Payment.fromFirestore(doc)).toList());
  }

  // Get payment by booking ID
  Future<Payment?> getPaymentByBookingId(String bookingId) async {
    final snapshot = await _firestore
        .collection('payments')
        .where('bookingId', isEqualTo: bookingId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Payment.fromFirestore(snapshot.docs.first);
  }

  // Calculate service price (demo pricing)
  double getServicePrice(String serviceName) {
    final prices = {
      'Plumbing': 1500.0,
      'Painting': 3000.0,
      'Electrician': 1200.0,
      'Home Inspection': 2500.0,
      '2D & 3D Design': 5000.0,
      'UPVC Roofing Installation': 8000.0,
      'Toughened Glass': 4000.0,
      'Aluminum Installation': 3500.0,
      'Smart Home Appliances Installation': 6000.0,
      'Home Finishing': 4500.0,
      'False Ceiling Installation': 5500.0,
      'Furnishing': 7000.0,
      'AC Repair': 2000.0,
      'Application Repair': 1000.0,
      'Home Remodeling': 10000.0,
      'House Map Design': 4000.0,
      'Bathroom Remodeling': 6000.0,
      'Railing Installation': 3000.0,
      'Hair Dresser': 800.0,
      'Modular Kitchen': 15000.0,
      'Pest Control': 2000.0,
    };

    return prices[serviceName] ?? 1500.0;
  }

  // Format price in Nepali Rupees
  String formatPrice(double amount) {
    return 'Rs. ${amount.toStringAsFixed(0)}';
  }
}

/// Result of payment callback handling
class PaymentCallbackResult {
  final bool success;
  final String message;
  final String? paymentId;
  final String? transactionId;

  PaymentCallbackResult({
    required this.success,
    required this.message,
    this.paymentId,
    this.transactionId,
  });
}

// Payment selection dialog widget
class PaymentMethodDialog extends StatelessWidget {
  final double amount;
  final Function(PaymentMethod) onMethodSelected;

  const PaymentMethodDialog({
    Key? key,
    required this.amount,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Amount: Rs. ${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            context,
            'eSewa',
            Icons.account_balance_wallet,
            Colors.green,
            PaymentMethod.esewa,
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(
            context,
            'Khalti',
            Icons.payment,
            Colors.purple,
            PaymentMethod.khalti,
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(
            context,
            'Cash on Delivery',
            Icons.money,
            Colors.orange,
            PaymentMethod.cashOnDelivery,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String name,
    IconData icon,
    Color color,
    PaymentMethod method,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onMethodSelected(method);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
