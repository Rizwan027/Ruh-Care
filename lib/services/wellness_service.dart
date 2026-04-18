import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruh_care/models/wellness_data.dart';

class WellnessService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<WellnessData?> getLatestWellnessData() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null || !snapshot.data()!.containsKey('wellnessData')) return null;
      return WellnessData.fromMap(snapshot.data()!['wellnessData']);
    });
  }

  Future<void> saveAssessment(WellnessData data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({
          'wellnessData': data.toMap()
        }, SetOptions(merge: true));
  }
}
