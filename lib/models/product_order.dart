import 'package:cloud_firestore/cloud_firestore.dart';

class ProductOrder {
  final String id;
  final String userId;
  final String productName;
  final double price;
  final String status;
  final DateTime orderDate;

  ProductOrder({
    required this.id,
    required this.userId,
    required this.productName,
    required this.price,
    required this.status,
    required this.orderDate,
  });

  factory ProductOrder.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductOrder(
      id: id,
      userId: data['userId'] ?? '',
      productName: data['productName'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productName': productName,
      'price': price,
      'status': status,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }
}
