import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Update Firebase Auth Display Name
      await currentUser.updateDisplayName(displayName);

      // Save to users collection in Firestore
      await _firestore.collection('users').doc(currentUser.uid).set({
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  String getUserName(Map<String, dynamic>? profile, User? user) {
    if (profile != null) {
      if (profile['fullName'] != null &&
          profile['fullName'].toString().isNotEmpty) {
        return profile['fullName'];
      }
      if (profile['displayName'] != null &&
          profile['displayName'].toString().isNotEmpty) {
        return profile['displayName'];
      }
    }
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    return 'User';
  }
}
