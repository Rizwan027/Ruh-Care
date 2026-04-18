import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruh_care/models/offline_course_request.dart';

class OfflineCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitRequest(OfflineCourseRequest request) async {
    try {
      await _firestore.collection('offline_course_requests').add(request.toMap());
    } catch (e) {
      print('Error submitting offline course request: $e');
      rethrow;
    }
  }

  Stream<List<OfflineCourseRequest>> getUserRequests(String userId) {
    return _firestore
        .collection('offline_course_requests')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final requests = snapshot.docs
              .map((doc) => OfflineCourseRequest.fromFirestore(doc.data(), doc.id))
              .toList();
          
          requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return requests;
        });
  }
}
