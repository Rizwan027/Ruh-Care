import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineCourseRequest {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String courseName;
  final String preferredDate;
  final String preferredTime;
  final String message;
  final String status;
  final DateTime createdAt;

  OfflineCourseRequest({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.courseName,
    required this.preferredDate,
    required this.preferredTime,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  factory OfflineCourseRequest.fromFirestore(Map<String, dynamic> data, String id) {
    return OfflineCourseRequest(
      id: id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      courseName: data['courseName'] ?? '',
      preferredDate: data['preferredDate'] ?? '',
      preferredTime: data['preferredTime'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'courseName': courseName,
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'message': message,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
