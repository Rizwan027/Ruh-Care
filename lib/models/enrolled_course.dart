import 'package:cloud_firestore/cloud_firestore.dart';

class EnrolledCourse {
  final String id;
  final String userId;
  final String courseName;
  final double progress;
  final DateTime enrolledAt;

  EnrolledCourse({
    required this.id,
    required this.userId,
    required this.courseName,
    required this.progress,
    required this.enrolledAt,
  });

  factory EnrolledCourse.fromFirestore(Map<String, dynamic> data, String id) {
    return EnrolledCourse(
      id: id,
      userId: data['userId'] ?? '',
      courseName: data['courseName'] ?? '',
      progress: (data['progress'] ?? 0).toDouble(),
      enrolledAt: (data['enrolledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseName': courseName,
      'progress': progress,
      'enrolledAt': Timestamp.fromDate(enrolledAt),
    };
  }
}
