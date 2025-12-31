import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized application configuration
/// Reads from environment variables (.env) with Firestore fallback
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cached config values from Firestore
  String? _firestoreProviderPhone;
  String? _firestoreProviderName;
  String? _firestoreProviderEmail;
  bool _isInitialized = false;

  /// Initialize configuration from Firestore (optional override)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final configDoc = await _firestore.collection('config').doc('app').get();
      if (configDoc.exists) {
        final data = configDoc.data()!;
        _firestoreProviderPhone = data['providerPhone'] as String?;
        _firestoreProviderName = data['providerName'] as String?;
        _firestoreProviderEmail = data['providerEmail'] as String?;
      }
    } catch (e) {
      // Use env defaults if Firestore fetch fails
    }
    _isInitialized = true;
  }

  /// Get the service provider phone number
  String get providerPhone =>
      _firestoreProviderPhone ??
      dotenv.env['DEFAULT_PROVIDER_PHONE'] ??
      '+9779800000000';

  /// Get the service provider name
  String get providerName =>
      _firestoreProviderName ??
      dotenv.env['DEFAULT_PROVIDER_NAME'] ??
      'Helpmandu Support';

  /// Get the service provider email
  String get providerEmail =>
      _firestoreProviderEmail ??
      dotenv.env['DEFAULT_PROVIDER_EMAIL'] ??
      'support@helpmandu.com';

  /// Check if the app is in production mode
  bool get isProduction =>
      dotenv.env['ENVIRONMENT'] == 'production' ||
      const bool.fromEnvironment('dart.vm.product');

  /// Payment gateway configuration
  PaymentConfig get payment => PaymentConfig(isProduction: isProduction);

  /// Update configuration in Firestore (admin use)
  Future<void> updateConfig({
    String? providerPhone,
    String? providerName,
    String? providerEmail,
  }) async {
    final updates = <String, dynamic>{};
    if (providerPhone != null) updates['providerPhone'] = providerPhone;
    if (providerName != null) updates['providerName'] = providerName;
    if (providerEmail != null) updates['providerEmail'] = providerEmail;

    if (updates.isNotEmpty) {
      await _firestore.collection('config').doc('app').set(
            updates,
            SetOptions(merge: true),
          );

      // Update cached values
      _firestoreProviderPhone = providerPhone ?? _firestoreProviderPhone;
      _firestoreProviderName = providerName ?? _firestoreProviderName;
      _firestoreProviderEmail = providerEmail ?? _firestoreProviderEmail;
    }
  }
}

/// Payment gateway configuration
/// All sensitive keys are read from environment variables
class PaymentConfig {
  final bool isProduction;

  PaymentConfig({required this.isProduction});

  // eSewa configuration
  String get esewaUrl => isProduction
      ? 'https://esewa.com.np/epay/main'
      : 'https://uat.esewa.com.np/epay/main';

  String get esewaMerchantId =>
      dotenv.env['ESEWA_MERCHANT_ID'] ?? 'EPAYTEST';

  // Khalti configuration
  String get khaltiUrl => isProduction
      ? 'https://pay.khalti.com/'
      : 'https://test-pay.khalti.com/';

  String get khaltiPublicKey =>
      dotenv.env['KHALTI_PUBLIC_KEY'] ?? '';

  // ReCaptcha for web App Check
  String get recaptchaSiteKey =>
      dotenv.env['RECAPTCHA_V3_SITE_KEY'] ?? '';

  // Deep link URLs for payment callbacks
  static const String successCallback = 'helpmandu://payment/success';
  static const String failureCallback = 'helpmandu://payment/failure';
}
