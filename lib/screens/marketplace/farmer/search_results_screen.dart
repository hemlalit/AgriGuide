import 'package:flutter/material.dart';
import 'package:AgriGuide/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/screens/marketplace/farmer/product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final searchResults = productProvider.products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: searchResults.isEmpty
          ? const Center(child: Text('No products found'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: searchResults.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 260, // Set a fixed height for each grid item
              ),
              itemBuilder: (context, index) {
                final product = searchResults[index];
                return ProductCard(product: product); // Product card widget
              },
            ),
    );
  }
}
