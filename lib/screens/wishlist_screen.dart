import 'package:flutter/material.dart';
import 'package:ruh_care/models/product.dart';
import 'package:ruh_care/services/cart_service.dart';
import 'package:ruh_care/services/wishlist_service.dart';
import 'package:ruh_care/screens/product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  
  static const Color _deepGreen = Color(0xFF2B4236);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _deepGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Saved for Later',
          style: TextStyle(color: _deepGreen, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: WishlistService(),
        builder: (context, _) {
          final items = WishlistService().items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: Color(0xFFF0F0EE)),
                  const SizedBox(height: 16),
                  Text('Your wishlist is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade400)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = items[index];
              return _buildWishlistItem(context, product);
            },
          );
        },
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)));
      },
      child: Container(
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
                image: DecorationImage(image: AssetImage(product.imagePath), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _deepGreen),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(product.size, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text('₹${product.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF6B8E67))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                  onPressed: () {
                    WishlistService().toggleWishlist(product);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    CartService().addToCart(product);
                    WishlistService().toggleWishlist(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Moved to cart!'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deepGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Move to Cart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
