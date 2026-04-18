import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ruh_care/models/course.dart';
import 'package:ruh_care/models/enrolled_course.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Course>> getCourses() {
    return _firestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Future<Course?> getCourseById(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      if (doc.exists) {
        return Course.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching course: $e');
      return null;
    }
  }

  Stream<List<EnrolledCourse>> getEnrolledCourses(String userId) {
    return _firestore
        .collection('enrolled_courses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => EnrolledCourse.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }
}
