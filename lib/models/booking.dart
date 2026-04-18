import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String therapyName;
  final String date;
  final String time;
  final String status;
  final DateTime createdAt;
  final double price;
  final DateTime appointmentDateTime;

  Booking({
    required this.id,
    required this.userId,
    required this.therapyName,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
    required this.price,
    required this.appointmentDateTime,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      userId: data['userId'] ?? '',
      therapyName: data['therapyName'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      status: data['status'] ?? 'Upcoming',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data['price'] ?? 0).toDouble(),
      appointmentDateTime: (data['appointmentDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'therapyName': therapyName,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'price': price,
      'appointmentDateTime': Timestamp.fromDate(appointmentDateTime),
    };
  }
}
