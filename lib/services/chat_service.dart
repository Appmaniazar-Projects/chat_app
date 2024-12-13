import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add(message.toJson());
  }

  Stream<List<Message>> getMessages(String currentUserId, String otherUserId) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [currentUserId, otherUserId])
        .where('receiverId', whereIn: [currentUserId, otherUserId])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> markMessageAsRead(String messageId) async {
    await _firestore
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
}
