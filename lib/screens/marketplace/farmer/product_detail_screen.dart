import 'dart:convert';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/models/product.dart';
import 'package:AgriGuide/providers/product_provider.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool? isLiked;
  const ProductDetailScreen({super.key, required this.product, this.isLiked});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const storage = FlutterSecureStorage();
  late bool _isLiked;
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
  void initState() {
    super.initState();
    _isLiked = widget.isLiked!;
    print(_isLiked);
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchVendorDetails(widget.product.vendorId);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.green.shade700,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      const Color.fromARGB(255, 0, 100, 0),
                      const Color.fromARGB(255, 0, 20, 0)
                    ]
                  : [Colors.lightGreen, const Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add to cart functionality
              productProvider.addToCart(widget.product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(LocaleData.addToCart.getString(context))),
              );
            },
            icon: const Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
            ),
          ),
        ], // Green AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.product.imageUrls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.product.imageUrls[0],
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ActionButton(icon: LikeButton(isLiked: _isLiked, onLiked: onLiked), label: label)
                  Icon(
                    _isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '₹ ${widget.product.price}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.product.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Divider(),
            _buildVendorDetailsSection(widget.product.vendorId),
            const Divider(),
            _buildGallerySection(widget.product.imageUrls),
            const Divider(),
            _buildReviewsSection(widget.product.reviews),
            const Divider(),
            _buildRecommendedProductsSection(),
            const Divider(),
            _buildComparisonSection(),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorDetailsSection(String vendorId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final vendor = provider.vendorDetails;

          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }

          if (vendor == null) {
            return const Center(child: Text('No vendor details available'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleData.vendorDetails.getString(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.formatString(
                    LocaleData.vendorName.getString(context), [vendor.name]),
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                context.formatString(
                    LocaleData.contact.getString(context), [vendor.phone]),
                style: const TextStyle(fontSize: 14),
              ),
              if (vendor.address != null) // Check if address is not null
                Text(
                  context.formatString(LocaleData.location.getString(context),
                      [vendor.address!.city, vendor.address!.state]),
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGallerySection(List<String> imageUrls) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleData.productGallery.getString(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: imageUrls.map((imageUrl) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildGalleryImage(imageUrl),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String imageUrl) {
    return Image.network(
      imageUrl,
      height: 400,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildReviewsSection(List<Review> reviews) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleData.reviews.getString(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow.shade600),
              const Icon(Icons.star, color: Colors.yellow),
              const Icon(Icons.star, color: Colors.yellow),
              const Icon(Icons.star, color: Colors.yellow),
              const Icon(Icons.star_border),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildReviewItem(review),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return ListTile(
      title: Text(review.comment),
      subtitle: Text(context
          .formatString(LocaleData.rating.getString(context), [review.rating])),
    );
  }

  Widget _buildRecommendedProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            LocaleData.recommedation.getString(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRecommendedProduct(
                  'Product 1', '₹ 200', 'https://picsum.photos/110'),
              const SizedBox(width: 8),
              _buildRecommendedProduct(
                  'Product 2', '₹ 300', 'https://picsum.photos/109'),
              const SizedBox(width: 8),
              _buildRecommendedProduct(
                  'Product 3', '₹ 150', 'https://picsum.photos/107'),
              const SizedBox(width: 8),
              _buildRecommendedProduct(
                  'Product 4', '₹ 150', 'https://picsum.photos/105'),
              const SizedBox(width: 8),
              _buildRecommendedProduct(
                  'Product 5', '₹ 150', 'https://picsum.photos/102'),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedProduct(String name, String price, String imageUrl) {
    return Column(
      children: [
        Image.network(
          imageUrl,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 14)),
        Text(price,
            style: TextStyle(fontSize: 14, color: Colors.green.shade700)),
      ],
    );
  }

  Widget _buildComparisonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            LocaleData.compare.getString(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        DataTable(
          columns: [
            DataColumn(label: Text(LocaleData.name.getString(context))),
            DataColumn(label: Text(LocaleData.price.getString(context))),
            DataColumn(label: Text(LocaleData.ratings.getString(context))),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Product A')),
              const DataCell(Text('₹ 250')),
              DataCell(Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow.shade600),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star_half, color: Colors.yellow),
                  const Icon(Icons.star_border),
                ],
              )),
            ]),
            DataRow(cells: [
              const DataCell(Text('Product B')),
              const DataCell(Text('₹ 275')),
              DataCell(Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow.shade600),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star_border),
                ],
              )),
            ]),
            DataRow(cells: [
              const DataCell(Text('Product C')),
              const DataCell(Text('₹ 300')),
              DataCell(Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow.shade600),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star, color: Colors.yellow),
                  const Icon(Icons.star_border),
                  const Icon(Icons.star_border),
                ],
              )),
            ]),
          ],
        ),
      ],
    );
  }
}
