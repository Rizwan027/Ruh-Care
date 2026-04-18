import 'package:flutter/material.dart';
import 'package:ruh_care/models/product.dart';

class WishlistService extends ChangeNotifier {
  static final WishlistService _instance = WishlistService._internal();

  factory WishlistService() {
    return _instance;
  }

  WishlistService._internal();

  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool isInWishlist(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}
