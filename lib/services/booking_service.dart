import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ruh_care/models/booking.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save a new booking
  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
    } catch (e) {
      debugPrint('Error creating booking: $e');
      rethrow;
    }
  }

  // Fetch all bookings for a user, ordered by date descending
  Stream<List<Booking>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          var bookings = snapshot.docs.map((doc) {
            final data = doc.data();
            var booking = Booking.fromFirestore(data, doc.id);
            // Auto complete if past and was upcoming
            if (booking.status == 'Upcoming' &&
                booking.appointmentDateTime.isBefore(now)) {
              _firestore.collection('bookings').doc(booking.id).update({
                'status': 'Completed',
              });
              booking = Booking.fromFirestore({
                ...data,
                'status': 'Completed',
              }, doc.id);
            }
            return booking;
          }).toList();

          // Local sort by descending time
          bookings.sort(
            (a, b) => b.appointmentDateTime.compareTo(a.appointmentDateTime),
          );
          return bookings;
        });
  }

  // Fetch upcoming bookings for dashboard (auto filters past due)
  Stream<List<Booking>> getUpcomingBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();

          final validBookings = snapshot.docs
              .map((doc) {
                final data = doc.data();
                var booking = Booking.fromFirestore(data, doc.id);

                if (booking.status == 'Upcoming' &&
                    booking.appointmentDateTime.isBefore(now)) {
                  // Mark as completed async, filter it out from 'Upcoming' right now
                  _firestore.collection('bookings').doc(doc.id).update({
                    'status': 'Completed',
                  });
                  booking = Booking.fromFirestore({
                    ...data,
                    'status': 'Completed',
                  }, doc.id);
                }
                return booking;
              })
              .where((b) => b.status == 'Upcoming')
              .toList();

          // Local sort by ascending time (closest upcoming first)
          validBookings.sort(
            (a, b) => a.appointmentDateTime.compareTo(b.appointmentDateTime),
          );
          return validBookings;
        });
  }
}
