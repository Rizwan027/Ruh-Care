import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ReceiptScreen extends StatefulWidget {
  final String paymentMethod;
  final List<ReceiptItem>? items;
  final double? total;

  const ReceiptScreen({
    super.key, 
    this.paymentMethod = 'Not Specified',
    this.items,
    this.total,
  });

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final String receiptId = 'BILL-${Random().nextInt(900000) + 100000}';
  late String date;
  late List<ReceiptItem> items;
  late double total;

  @override
  void initState() {
    super.initState();
    date = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    
    // Use passed items or default to empty
    items = widget.items ?? [];
    total = widget.total ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EC),
      appBar: AppBar(
        title: const Text(
          'Invoice',
          style: TextStyle(color: Color(0xFF2B4236), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2B4236)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF2B4236)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading bill...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              _buildHandmadeBill(context),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B4236),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text('Return', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bill has been saved to your downloads')),
                  );
                },
                child: const Text(
                  'Download Bill (PDF)',
                  style: TextStyle(color: Color(0xFF6B8E67), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandmadeBill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF7), // Parchment color
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Branding Header
          const Center(
            child: Text(
              'RUH CARE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
                color: Color(0xFF2B4236),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Premium Natural Wellness',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                color: Color(0xFF6B8E67),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _buildBillRow('Invoice No.', receiptId, isBold: true),
          const SizedBox(height: 6),
          _buildBillRow('Date', date),
          const SizedBox(height: 6),
          _buildBillRow('Status', 'PAID', valueColor: Colors.green.shade700),
          const SizedBox(height: 6),
          _buildBillRow('Method', widget.paymentMethod),
          
          const SizedBox(height: 24),
          _buildDashedLine(),
          const SizedBox(height: 24),

          // Items Table Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF2B4236),
                ),
              ),
              Text(
                'AMOUNT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF2B4236),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Item List
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No items in this invoice')),
            )
          else
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2B4236),
                            ),
                          ),
                          Text(
                            '${item.quantity} x ₹${item.price.toInt()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '₹${(item.price * item.quantity).toInt()}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2B4236),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 16),
          _buildDashedLine(),
          const SizedBox(height: 16),

          // Total Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GRAND TOTAL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B4236),
                ),
              ),
              Text(
                '₹${total.toInt()}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B4236),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Barcode Section
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      50,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 1.5),
                        width: (index % 7 == 0 || index % 11 == 0) ? 2.0 : 1.0,
                        color: const Color(0xFF2B4236),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  receiptId,
                  style: const TextStyle(
                    letterSpacing: 4,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B4236),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          const Center(
            child: Text(
              'Thank you for choosing Ruh Care',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: Color(0xFF6B8E67),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'www.ruhcare.com',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF2B4236),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}

class ReceiptItem {
  final String name;
  final int quantity;
  final double price;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
