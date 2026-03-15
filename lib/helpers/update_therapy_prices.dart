import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateTherapyPrices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updatePricesToRupees() async {
    // Realistic Indian clinic prices
    final Map<String, int> therapyPrices = {
      'Dry Cupping': 800,
      'Wet Cupping (Hijama)': 1500,
      'Fire Cupping': 1000,
      'Leech Therapy': 2000,
      'Acupuncture': 1200,
      'Kasa Thali Therapy': 600,
    };

    try {
      // Fetch all therapies
      final snapshot = await _firestore.collection('therapies').get();

      for (var doc in snapshot.docs) {
        final therapyName = doc.data()['name'] as String;

        if (therapyPrices.containsKey(therapyName)) {
          // Update the price field
          await doc.reference.update({'price': therapyPrices[therapyName]});
          print(
            '✅ Updated price for: $therapyName to ₹${therapyPrices[therapyName]}',
          );
        }
      }

      print('🎉 All therapy prices updated to rupees!');
    } catch (e) {
      print('❌ Error updating prices: $e');
    }
  }
}
