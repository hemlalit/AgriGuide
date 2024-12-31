import 'dart:convert';

import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/models/product.dart';
import 'package:AgriGuide/screens/marketplace/farmer/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static const storage = FlutterSecureStorage();
  String? userId;

  Future<void> _fetchUser() async {
    final user = await storage.read(key: 'userData');
    print(user);

    if (user != null) {
      final Map<String, dynamic> userData = jsonDecode(user);
      setState(() {
        userId = userData['_id'];
      });
    } else {
      print('No user data found');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: widget.product,
              isLiked: widget.product.likes.contains(userId)
            ),
          ),
        );
      },
      child: cardLayout(widget.product),
    );
  }

  Widget cardLayout(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.green.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                height: 100, // Reduced height for a more compact card
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Smaller font size
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 12, // Smaller font size
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.formatString(LocaleData.category.getString(context), [product.category]),
                    style: const TextStyle(
                      fontSize: 12, // Smaller font size
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.formatString(LocaleData.stock.getString(context), [product.stock]),
                    style: const TextStyle(
                      fontSize: 12, // Smaller font size
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Smaller font size
                          color: Colors.green,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 16, // Smaller icon size
                            color: Colors.red,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${product.likes.length}',
                            style: const TextStyle(
                              fontSize: 12, // Smaller font size
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
