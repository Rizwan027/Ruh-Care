import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Wellness Store',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Natural products for your health',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(fontSize: 14, color: const Color(0xFF2D3436).withAlpha(100)),
                  prefixIcon: Icon(Icons.search, color: const Color(0xFF6B7B3A).withAlpha(160)),
                  filled: true,
                  fillColor: const Color(0xFFF8F8F6),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE4E4E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE4E4E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF6B7B3A), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                  children: [
                    _buildProductTile('Talbina with\nDry Fruits', '250g', '₹300'),
                    _buildProductTile('Olive Oil', '500ml', '₹900'),
                    _buildProductTile('Olive Oil', '200ml', '₹330'),
                    _buildProductTile('Sirka\n(Anar & Olive)', '500ml', '₹300'),
                    _buildProductTile('Ajwah Khajoor\nPowder', '100g', '₹600'),
                    _buildProductTile('Badam Oil\n(Spain)', '100ml', '₹370'),
                    _buildProductTile('Shilajit', '10g', '₹500'),
                    _buildProductTile('Zafran', '1g', '₹450'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildProductTile(String name, String size, String price) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFEFEDE8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 40, color: Color(0xFFB0A899)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    size,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A8A)),
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF6B7B3A)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
