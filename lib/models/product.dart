import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String authorName;
  final double rating;
  final String comment;
  final DateTime date;
  final bool isVerifiedPurchase;
  final List<String>? reviewImages;

  const Review({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
    this.isVerifiedPurchase = false,
    this.reviewImages,
  });

  factory Review.fromFirestore(Map<String, dynamic> data, String docId) {
    return Review(
      id: docId,
      authorName: data['authorName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      isVerifiedPurchase: data['isVerifiedPurchase'] ?? false,
      reviewImages: data['reviewImages'] != null
          ? List<String>.from(data['reviewImages'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorName': authorName,
      'rating': rating,
      'comment': comment,
      'date': date,
      'isVerifiedPurchase': isVerifiedPurchase,
      'reviewImages': reviewImages,
    };
  }
}

class Product {
  final String id;
  final String name;
  final String size;
  final double price;
  final String imagePath;
  final String description;
  final List<Review> reviews;

  double get averageRating {
    if (reviews.isEmpty) return 0;
    double sum = 0;
    for (var r in reviews) {
      sum += r.rating;
    }
    return sum / reviews.length;
  }

  int get reviewCount => reviews.length;

  const Product({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.imagePath,
    this.description =
        'Experience the pure, natural benefits of this premium wellness product.',
    this.reviews = const [],
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? '',
      size: data['size'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
      reviews:
          (data['reviews'] as List<dynamic>?)
              ?.map(
                (r) => Review.fromFirestore(
                  r as Map<String, dynamic>,
                  r['id'] ?? '',
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'size': size,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'reviews': reviews.map((r) => r.toFirestore()).toList(),
    };
  }
}
