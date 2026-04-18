import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ruh_care/models/therapy.dart';

class TherapyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all therapies
  Stream<List<Therapy>> getTherapies() {
    return _firestore.collection('therapies').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Therapy.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // Fetch therapies by category
  Stream<List<Therapy>> getTherapiesByCategory(String category) {
    return _firestore
        .collection('therapies')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Therapy.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  // Get single therapy by ID
  Future<Therapy?> getTherapyById(String therapyId) async {
    try {
      final doc = await _firestore.collection('therapies').doc(therapyId).get();
      if (doc.exists) {
        return Therapy.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching therapy: $e');
      return null;
    }
  }
}
