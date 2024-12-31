class Review {
  final String userId;
  final String comment;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.userId,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'] ?? '',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final int stock;
  String vendorId;
  final List<String> likes; // Updated to use a list of user IDs
  final List<Review> reviews;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrls = const [], // Ensure imageUrls is initialized as an empty list
    required this.stock,
    required this.vendorId,
    this.likes = const [], // Ensure likes is initialized as an empty list
    this.reviews = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []), // Ensure imageUrls is a list of strings
      stock: json['stock'] ?? 0,
      vendorId: json['vendorId'] ?? '',
      likes: List<String>.from(json['likes'] ?? []), // Ensure likes is a list of user IDs
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((reviewJson) => Review.fromJson(reviewJson))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'stock': stock,
      'vendorId': vendorId,
      'likes': likes, // Convert likes to JSON
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
