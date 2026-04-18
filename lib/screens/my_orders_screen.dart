import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruh_care/models/product_order.dart';
import 'package:ruh_care/services/order_service.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final orderService = OrderService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: user == null
          ? const Center(child: Text('Please login to view orders'))
          : StreamBuilder<List<ProductOrder>>(
              stream: orderService.getUserOrders(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6B7B3A)),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No orders found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final orders = snapshot.data!;
                final now = DateTime.now();

                final recentOrders = orders
                    .where((o) => now.difference(o.orderDate).inDays <= 30)
                    .toList();
                final previousOrders = orders
                    .where((o) => now.difference(o.orderDate).inDays > 30)
                    .toList();

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (recentOrders.isNotEmpty) ...[
                      const Text(
                        'Recent Orders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...recentOrders.map((order) => _buildOrderCard(order)),
                      const SizedBox(height: 24),
                    ],
                    if (previousOrders.isNotEmpty) ...[
                      const Text(
                        'Previous Orders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...previousOrders.map((order) => _buildOrderCard(order)),
                    ],
                  ],
                );
              },
            ),
    );
  }

  Widget _buildOrderCard(ProductOrder order) {
    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case 'Delivered':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Processing':
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_top;
        break;
      case 'Shipped':
        statusColor = Colors.purple;
        statusIcon = Icons.local_shipping;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag, color: Color(0xFF6B7B3A)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ordered on ${DateFormat('MMM dd, yyyy').format(order.orderDate)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${order.price.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7B3A),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withAlpha(76)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 18, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 13,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
