import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UpdateTherapyImages {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateTherapyImages() async {
    // Image URLs for each therapy
    final Map<String, String> therapyImages = {
      'Dry Cupping':
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400',
      'Wet Cupping (Hijama)':
          'https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=400',
      'Fire Cupping':
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=400',
      'Leech Therapy':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
      'Acupuncture':
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
      'Kasa Thali Therapy':
          'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?w=400',
    };

    try {
      // Fetch all therapies
      final snapshot = await _firestore.collection('therapies').get();

      for (var doc in snapshot.docs) {
        final therapyName = doc.data()['name'] as String;

        if (therapyImages.containsKey(therapyName)) {
          // Update the imageUrl field
          await doc.reference.update({'imageUrl': therapyImages[therapyName]});
          debugPrint('✅ Updated image for: $therapyName');
        }
      }

      debugPrint('🎉 All therapy images updated successfully!');
    } catch (e) {
      debugPrint('❌ Error updating images: $e');
    }
  }
}
