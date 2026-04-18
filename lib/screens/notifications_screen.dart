import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruh_care/models/app_notification.dart';
import 'package:ruh_care/services/notification_service.dart';
import 'package:ruh_care/services/order_service.dart';
import 'package:ruh_care/screens/receipt_screen.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final notificationService = NotificationService();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF2B4236),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF1F3EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B4236)),
      ),
      body: user == null
          ? const Center(child: Text('Please login to view notifications'))
          : StreamBuilder<List<AppNotification>>(
              stream: notificationService.getUserNotifications(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2B4236)),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notifications available',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final notifications = snapshot.data!;

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    return InkWell(
                      onTap: () async {
                        if (notification.message.toLowerCase().contains(
                          'bill',
                        )) {
                          // Redirect to the latest bill
                          final orderService = OrderService();
                          // We fetch the stream once and take the first list of orders
                          final orders = await orderService
                              .getUserOrders(user.uid)
                              .first;
                          if (orders.isNotEmpty && context.mounted) {
                            // For simplicity, we show the latest order as the bill
                            // In a real app, you'd group orders by a shared Transaction ID
                            final latestOrder = orders.first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptScreen(
                                  paymentMethod: 'GPay/COD',
                                  items: [
                                    ReceiptItem(
                                      name: latestOrder.productName,
                                      quantity:
                                          1, // Quantity is already in the name string "1x ..."
                                      price: latestOrder.price,
                                    ),
                                  ],
                                  total: latestOrder.price,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFE4E8D8)),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2B4236).withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Color(0xFF2B4236),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.message,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFF2B4236),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy • hh:mm a',
                                    ).format(notification.createdAt),
                                    style: const TextStyle(
                                      color: Color(0xFF6B8E67),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
