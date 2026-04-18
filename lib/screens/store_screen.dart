import 'package:flutter/material.dart';
import 'package:ruh_care/models/product.dart';
import 'package:ruh_care/services/cart_service.dart';
import 'package:ruh_care/screens/product_details_screen.dart';
import 'package:ruh_care/screens/cart_screen.dart';
import 'package:ruh_care/services/wishlist_service.dart';
import 'package:ruh_care/screens/wishlist_screen.dart';
import 'package:ruh_care/services/product_service.dart';
import 'package:ruh_care/helpers/sample_data_helper.dart';
import 'package:ruh_care/helpers/responsive_helper.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ProductService _productService = ProductService();
  final SampleDataHelper _sampleDataHelper = SampleDataHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];
  bool _isSeeding = true;
  int _streamKey = 0;

  // Use the homepage deep green
  final Color _deepGreen = const Color(0xFF2B4236);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _seedSampleProductsIfNeeded();
    });
  }

  Future<void> _seedSampleProductsIfNeeded() async {
    try {
      await _sampleDataHelper.addSampleProductsIfEmpty();
    } catch (e) {
      debugPrint('Seeding error: $e');
    }
    if (mounted) {
      setState(() {
        _isSeeding = false;
        _streamKey++;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _isSeeding ? _buildLoading() : _buildProductGrid(),
                  ),
                ],
              ),
            ),
          ),

          // Floating View Cart Bar
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ListenableBuilder(
              listenable: CartService(),
              builder: (context, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: CartService().totalItems > 0
                      ? _buildFloatingCartBar()
                      : const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wellness Store',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _deepGreen,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Natural products for your health',
                style: TextStyle(fontSize: 13, color: _deepGreen.withAlpha(128)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoundIconButton(
              icon: Icons.favorite_border,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              ),
              badgeCountGetter: () => WishlistService().items.length,
              badgeColor: Colors.redAccent,
              listenable: WishlistService(),
            ),
            const SizedBox(width: 12),
            _buildRoundIconButton(
              icon: Icons.shopping_cart_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              badgeCountGetter: () => CartService().totalItems,
              badgeColor: Colors.redAccent,
              listenable: CartService(),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildRoundIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required int Function() badgeCountGetter,
    required Color badgeColor,
    required Listenable listenable,
  }) {
    return ListenableBuilder(
      listenable: listenable,
      builder: (context, _) {
        final count = badgeCountGetter();
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Icon(icon, color: _deepGreen, size: 26),
            ),
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterProducts,
      style: TextStyle(color: _deepGreen),
      decoration: InputDecoration(
        hintText: 'Search products...',
        hintStyle: TextStyle(fontSize: 14, color: _deepGreen.withAlpha(77)),
        prefixIcon: Icon(Icons.search, color: _deepGreen.withAlpha(128)),
        filled: true,
        fillColor: const Color(0xFFF1F3EC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator(color: _deepGreen));
  }
  Widget _buildProductGrid() {
    return StreamBuilder<List<Product>>(
      key: ValueKey(_streamKey),
      stream: _productService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        _allProducts = snapshot.data!;
        if (_searchController.text.isEmpty) {
          _filteredProducts = _allProducts;
        }

        final isSmall = Responsive.isSmallScreen(context);

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 80, top: 4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isSmall ? 1 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: isSmall ? 1.2 : 0.7, // Better ratio for 1-col
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(_filteredProducts[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: _deepGreen.withAlpha(25),
          ),
          const SizedBox(height: 16),
          const Text('No products found', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final isSmall = Responsive.isSmallScreen(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              ).then((_) => setState(() {}));
            },
            child: isSmall 
              ? Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildProductImage(product),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: _buildProductInfo(product),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 12,
                      child: _buildProductImage(product),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _buildProductInfo(product),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Hero(
      tag: 'product_image_${product.id}',
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F3EC),
            ),
            child: Image.asset(
              product.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 16,
                  ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _buildWishlistButton(product),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: _deepGreen,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          product.size,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B8E67),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹${product.price.toInt()}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: _deepGreen,
          ),
        ),
        const SizedBox(height: 10),
        _buildAddToCartButton(product),
      ],
    );
  }

  Widget _buildWishlistButton(Product product) {
    return ListenableBuilder(
      listenable: WishlistService(),
      builder: (context, _) {
        final isSaved = WishlistService().isInWishlist(product);
        return GestureDetector(
          onTap: () => WishlistService().toggleWishlist(product),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(230),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.redAccent : _deepGreen,
              size: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddToCartButton(Product product) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          CartService().addToCart(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to cart!'),
              backgroundColor: _deepGreen,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 1000),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _deepGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Add to Cart',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFloatingCartBar() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _deepGreen,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.shopping_basket, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'View cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${CartService().totalItems} Items',
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
