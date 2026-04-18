import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ruh_care/models/product_order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(ProductOrder order) async {
    try {
      await _firestore.collection('product_orders').add(order.toMap());
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow;
    }
  }

  Stream<List<ProductOrder>> getUserOrders(String userId) {
    return _firestore
        .collection('product_orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => ProductOrder.fromFirestore(doc.data(), doc.id))
              .toList();

          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        });
  }
}
