import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String userId;
  final String message;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
  });

  factory AppNotification.fromFirestore(Map<String, dynamic> data, String id) {
    return AppNotification(
      id: id,
      userId: data['userId'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
