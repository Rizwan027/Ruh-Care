import 'package:flutter/material.dart';
import 'package:ruh_care/models/product.dart';
import 'package:ruh_care/services/cart_service.dart';
import 'package:ruh_care/services/wishlist_service.dart';
import 'package:ruh_care/services/product_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  int selectedUnitIndex = 0;
  final ProductService _productService = ProductService();
  
  // Brand green
  final Color _deepGreen = const Color(0xFF2B4236);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. App Bar with Image
              SliverAppBar(
                expandedHeight: 350,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: _deepGreen, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_image_${widget.product.id}',
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Color(0xFFF1F3EC)),
                      child: Image.asset(
                        widget.product.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: TextStyle(
                                color: _deepGreen,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '₹${widget.product.price.toInt()}',
                            style: TextStyle(
                              color: _deepGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Ratings
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: TextStyle(color: _deepGreen, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(7 reviews)',
                            style: TextStyle(color: _deepGreen.withOpacity(0.5), fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.product.size,
                        style: const TextStyle(color: Color(0xFF6B8E67), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(color: Color(0xFF2B4236), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: TextStyle(color: _deepGreen.withOpacity(0.7), fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 32),

                      // Customer Reviews
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(color: Color(0xFF2B4236), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildReviewCard('Sarah K.', 'Absolutely love this! It has completely changed my daily morning routine. Tastes incredibly natural.', 5),
                      const SizedBox(height: 12),
                      _buildReviewCard('Ahmed M.', 'Great quality and fast delivery. Very satisfying.', 5),
                      
                      const SizedBox(height: 120), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Sticky Bottom Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String comment, int rating) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(color: _deepGreen, fontWeight: FontWeight.bold, fontSize: 14)),
              Row(
                children: List.generate(5, (index) => Icon(Icons.star, size: 12, color: index < rating ? Colors.amber : Colors.grey.shade300)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.verified, size: 12, color: Color(0xFF6B8E67)),
              const SizedBox(width: 4),
              Text('Verified Purchase', style: TextStyle(color: const Color(0xFF6B8E67), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment, style: TextStyle(color: _deepGreen.withOpacity(0.7), fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quantity Selector
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildQtyBtn(Icons.remove, () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$quantity', style: TextStyle(color: _deepGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _buildQtyBtn(Icons.add, () => setState(() => quantity++)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Add to Cart
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    CartService().addToCart(widget.product, quantity: quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added to cart!'),
                        backgroundColor: _deepGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deepGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 18, color: _deepGreen),
    );
  }
}
