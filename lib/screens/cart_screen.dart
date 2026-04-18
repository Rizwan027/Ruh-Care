import 'package:flutter/material.dart';
import 'package:ruh_care/services/cart_service.dart';
import 'package:ruh_care/services/wishlist_service.dart';
import 'package:ruh_care/screens/receipt_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruh_care/models/product_order.dart';
import 'package:ruh_care/services/order_service.dart';
import 'package:ruh_care/models/app_notification.dart';
import 'package:ruh_care/services/notification_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  static const Color _deepGreen = Color(0xFF2B4236);

  void _showCheckoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _deepGreen,
              ),
            ),
            const SizedBox(height: 20),
            // COD Option
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pop(ctx);
                _showCodConfirmation(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF0F0EE)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.money_rounded, color: Colors.green, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.bold, color: _deepGreen, fontSize: 16)),
                          Text('Pay when your order arrives', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // GPay Option
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pop(ctx);
                _showGpaySheet(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF0F0EE)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Google Pay (GPay)', style: TextStyle(fontWeight: FontWeight.bold, color: _deepGreen, fontSize: 16)),
                          Text('Pay instantly via UPI', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCodConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.money_rounded, color: Colors.green),
            ),
            const SizedBox(width: 12),
            const Text('Cash on Delivery', style: TextStyle(color: _deepGreen, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please keep the exact amount ready at the time of delivery.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Our delivery agent will collect payment.',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _generateReceipt(context, 'Cash on Delivery');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _deepGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(100, 44),
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }

  void _showGpaySheet(BuildContext context) {
    final amountController = TextEditingController();
    final upiController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GPay Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 32),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Google Pay', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: _deepGreen)),
                    Text('Secure UPI Payment', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Amount display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('Amount to Pay', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    '₹${CartService().totalPrice.toInt()}',
                    style: const TextStyle(color: _deepGreen, fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // UPI ID Field
            TextField(
              controller: upiController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: _deepGreen),
              decoration: InputDecoration(
                labelText: 'Enter UPI ID',
                hintText: 'yourname@upi',
                prefixIcon: const Icon(Icons.account_circle_outlined, color: _deepGreen),
                filled: true,
                fillColor: const Color(0xFFF1F3EC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            // Pay button
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (upiController.text.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid UPI ID')),
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  _showGpayProcessing(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8), // Google Blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text('Pay ₹${CartService().totalPrice.toInt()} via GPay',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGpayProcessing(BuildContext context) {
    // Show a processing dialog that simulates payment
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _GpayProcessingDialog(
        onSuccess: () {
          Navigator.pop(ctx);
          _generateReceipt(context, 'Google Pay');
        },
      ),
    );
  }

  Future<void> _generateReceipt(
    BuildContext context,
    String paymentMethod,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    final cartService = CartService();

    if (user != null && cartService.items.isNotEmpty) {
      final orderService = OrderService();
      final notificationService = NotificationService();
      
      // Snapshot items for receipt before clearing cart
      final receiptItems = cartService.items.map((i) => ReceiptItem(
        name: i.product.name,
        quantity: i.quantity,
        price: i.product.price,
      )).toList();
      final totalAmount = cartService.totalPrice;

      int totalItems = 0;
      bool allOrdersSuccess = true;

      for (var item in cartService.items) {
        final order = ProductOrder(
          id: '',
          userId: user.uid,
          productName: '${item.quantity}x ${item.product.name}',
          price: item.product.price * item.quantity,
          status: 'Processing',
          orderDate: DateTime.now(),
        );
        try {
          await orderService.createOrder(order);
          totalItems += item.quantity;
        } catch (e) {
          debugPrint('Order creation failed: $e');
          allOrdersSuccess = false;
        }
      }

      if (allOrdersSuccess) {
        cartService.clearCart();
        final notif = AppNotification(
          id: '',
          userId: user.uid,
          message: 'Order successful! Click to view and download your bill.',
          createdAt: DateTime.now(),
        );
        await notificationService.createNotification(notif);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Some orders failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            paymentMethod: paymentMethod,
            items: receiptItems,
            total: totalAmount,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: _deepGreen, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _deepGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: cartService,
          builder: (context, child) {
            if (cartService.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Color(0xFFF0F0EE),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _deepGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Start Shopping', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartService.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cartService.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF0F0EE)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F3EC),
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(item.product.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(color: _deepGreen, fontSize: 14, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item.product.price.toInt()}',
                                    style: const TextStyle(color: Color(0xFF6B8E67), fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _QuantityButton(
                                        icon: Icons.remove,
                                        onTap: () => cartService.updateQuantity(item.product.id, item.quantity - 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text('${item.quantity}', style: const TextStyle(color: _deepGreen, fontWeight: FontWeight.bold)),
                                      ),
                                      _QuantityButton(
                                        icon: Icons.add,
                                        onTap: () => cartService.updateQuantity(item.product.id, item.quantity + 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                  onPressed: () => cartService.removeFromCart(item.product.id),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                                  onPressed: () {
                                    cartService.removeFromCart(item.product.id);
                                    WishlistService().toggleWishlist(item.product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Saved for later'), behavior: SnackBarBehavior.floating),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', '₹${cartService.totalPrice.toInt()}'),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Shipping', 'Free', isGreen: true),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(color: _deepGreen, fontSize: 18, fontWeight: FontWeight.w900)),
                          Text('₹${cartService.totalPrice.toInt()}', style: const TextStyle(color: Color(0xFF6B8E67), fontSize: 22, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _showCheckoutOptions(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _deepGreen,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        Text(value, style: TextStyle(color: isGreen ? const Color(0xFF6B8E67) : _deepGreen, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3EC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF0F0EE)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF2B4236)),
      ),
    );
  }
}

class _GpayProcessingDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  const _GpayProcessingDialog({required this.onSuccess});

  @override
  State<_GpayProcessingDialog> createState() => _GpayProcessingDialogState();
}

class _GpayProcessingDialogState extends State<_GpayProcessingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate payment processing for 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() => _done = true);
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) widget.onSuccess();
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Google Pay Logo area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _done ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _done
                    ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48, key: ValueKey('done'))
                    : RotationTransition(
                        turns: _animController,
                        child: const Icon(Icons.g_mobiledata_rounded, color: Colors.blue, size: 48, key: ValueKey('loading')),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _done ? 'Payment Successful!' : 'Processing Payment...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _done ? Colors.green.shade700 : const Color(0xFF2B4236),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _done ? 'Your order has been confirmed.' : 'Please wait while we verify your payment.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            if (!_done)
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade200,
                color: const Color(0xFF1A73E8),
                borderRadius: BorderRadius.circular(4),
              ),
          ],
        ),
      ),
    );
  }
}

