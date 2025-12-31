import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

/// Service provider model
class ServiceProvider {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> services;
  final double rating;
  final int totalJobs;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final String? profileImageUrl;
  final Map<String, dynamic>? availability;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.services,
    this.rating = 0.0,
    this.totalJobs = 0,
    this.isActive = true,
    this.isVerified = false,
    required this.createdAt,
    this.profileImageUrl,
    this.availability,
  });

  factory ServiceProvider.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceProvider(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      services: List<String>.from(data['services'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      totalJobs: data['totalJobs'] ?? 0,
      isActive: data['isActive'] ?? true,
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      profileImageUrl: data['profileImageUrl'],
      availability: data['availability'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'services': services,
      'rating': rating,
      'totalJobs': totalJobs,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'profileImageUrl': profileImageUrl,
      'availability': availability,
    };
  }
}

/// Provider service for managing service providers
class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();

  // Default provider for backward compatibility
  static const String defaultProviderId = 'helpmandu_default_provider';
  static const String defaultProviderName = 'Helpmandu Support';

  /// Get all active providers for a specific service
  Future<List<ServiceProvider>> getProvidersForService(String serviceName) async {
    try {
      final snapshot = await _firestore
          .collection('providers')
          .where('services', arrayContains: serviceName)
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs.map((doc) => ServiceProvider.fromFirestore(doc)).toList();
    } catch (e) {
      // Return empty list if query fails (e.g., no index)
      return [];
    }
  }

  /// Get a specific provider by ID
  Future<ServiceProvider?> getProvider(String providerId) async {
    // Handle default provider case
    if (providerId == defaultProviderId) {
      return _getDefaultProvider();
    }

    final doc = await _firestore.collection('providers').doc(providerId).get();
    if (!doc.exists) return null;
    return ServiceProvider.fromFirestore(doc);
  }

  /// Get provider for a booking (finds best available or returns default)
  Future<ServiceProvider> getProviderForBooking(String serviceName) async {
    final providers = await getProvidersForService(serviceName);

    if (providers.isEmpty) {
      return _getDefaultProvider();
    }

    // Return the highest-rated active provider
    return providers.first;
  }

  /// Get the default provider (fallback)
  ServiceProvider _getDefaultProvider() {
    return ServiceProvider(
      id: defaultProviderId,
      name: defaultProviderName,
      email: 'support@helpmandu.com',
      phone: '+9779851140485',
      services: [],
      rating: 5.0,
      totalJobs: 0,
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now(),
    );
  }

  /// Register a new provider (for future provider app)
  Future<ServiceProvider> registerProvider({
    required String name,
    required String email,
    required String phone,
    required List<String> services,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final providerId = userId; // Use auth UID as provider ID
    final provider = ServiceProvider(
      id: providerId,
      name: name,
      email: email,
      phone: phone,
      services: services,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('providers')
        .doc(providerId)
        .set(provider.toFirestore());

    return provider;
  }

  /// Update provider rating after a job completion
  Future<void> updateProviderRating({
    required String providerId,
    required double newRating,
  }) async {
    if (providerId == defaultProviderId) return;

    final doc = await _firestore.collection('providers').doc(providerId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final currentRating = (data['rating'] ?? 0).toDouble();
    final totalJobs = (data['totalJobs'] ?? 0) as int;

    // Calculate new average rating
    final newTotalJobs = totalJobs + 1;
    final newAvgRating = ((currentRating * totalJobs) + newRating) / newTotalJobs;

    await _firestore.collection('providers').doc(providerId).update({
      'rating': newAvgRating,
      'totalJobs': newTotalJobs,
    });
  }

  /// Get all providers (for admin)
  Stream<List<ServiceProvider>> getAllProviders() {
    return _firestore
        .collection('providers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ServiceProvider.fromFirestore(doc)).toList());
  }

  /// Update provider status
  Future<void> updateProviderStatus({
    required String providerId,
    bool? isActive,
    bool? isVerified,
  }) async {
    final updates = <String, dynamic>{};
    if (isActive != null) updates['isActive'] = isActive;
    if (isVerified != null) updates['isVerified'] = isVerified;

    if (updates.isNotEmpty) {
      await _firestore.collection('providers').doc(providerId).update(updates);
    }
  }
}
