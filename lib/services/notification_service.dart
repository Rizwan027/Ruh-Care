import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruh_care/models/app_notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNotification(AppNotification notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toMap());
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  Stream<List<AppNotification>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final notifications = snapshot.docs
              .map((doc) => AppNotification.fromFirestore(doc.data(), doc.id))
              .toList();
              
          notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return notifications;
        });
  }
}
