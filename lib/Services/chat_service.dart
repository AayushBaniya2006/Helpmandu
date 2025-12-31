import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'notification_service.dart';
import 'provider_service.dart';

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      receiverId: data['receiverId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

class ChatRoom {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String serviceName;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.serviceName,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      serviceName: data['serviceName'] ?? '',
      unreadCount: data['unreadCount'] ?? 0,
    );
  }
}

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();
  final ProviderService _providerService = ProviderService();
  final Uuid _uuid = const Uuid();

  String? get currentUserId => _auth.currentUser?.uid;
  String? get currentUserName => _auth.currentUser?.displayName;

  // Get or create chat room with service provider
  Future<String> getOrCreateChatRoom(String serviceName) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // Check if chat room already exists
    final existingRoom = await _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .where('serviceName', isEqualTo: serviceName)
        .limit(1)
        .get();

    if (existingRoom.docs.isNotEmpty) {
      return existingRoom.docs.first.id;
    }

    // Get the appropriate provider for this service
    final provider = await _providerService.getProviderForBooking(serviceName);

    // Create new chat room
    final roomId = _uuid.v4();
    await _firestore.collection('chatRooms').doc(roomId).set({
      'participants': [userId, provider.id],
      'providerId': provider.id,
      'providerName': provider.name,
      'serviceName': serviceName,
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
      'unreadCount': 0,
      'createdAt': Timestamp.now(),
    });

    return roomId;
  }

  // Send message
  Future<void> sendMessage({
    required String chatRoomId,
    required String text,
  }) async {
    final userId = currentUserId;
    final userName = currentUserName ?? 'User';
    if (userId == null) throw Exception('User not authenticated');

    // Get the chat room to find the provider ID
    final chatRoomDoc = await _firestore.collection('chatRooms').doc(chatRoomId).get();
    final chatRoomData = chatRoomDoc.data();
    final providerId = chatRoomData?['providerId'] ?? ProviderService.defaultProviderId;

    final messageId = _uuid.v4();
    final message = Message(
      id: messageId,
      senderId: userId,
      senderName: userName,
      receiverId: providerId,
      text: text,
      timestamp: DateTime.now(),
    );

    // Add message to subcollection
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .set(message.toFirestore());

    // Update chat room with last message
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': text,
      'lastMessageTime': Timestamp.now(),
      'unreadCount': FieldValue.increment(1),
    });
  }

  // Get messages stream for a chat room
  Stream<List<Message>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  // Get chat rooms for current user
  Stream<List<ChatRoom>> getChatRooms() {
    final userId = currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList());
  }

  // Mark messages as read
  Future<void> markAsRead(String chatRoomId) async {
    final userId = currentUserId;
    if (userId == null) return;

    // Update unread count
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'unreadCount': 0,
    });

    // Mark all messages as read
    final unreadMessages = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  // Delete chat room
  Future<void> deleteChatRoom(String chatRoomId) async {
    // Delete all messages first
    final messages = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    // Delete the chat room
    await _firestore.collection('chatRooms').doc(chatRoomId).delete();
  }
}
