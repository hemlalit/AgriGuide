import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/product_provider.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/screens/marketplace/farmer/carousel_banner.dart';
import 'package:AgriGuide/screens/marketplace/farmer/product_detail_screen.dart';
import 'package:AgriGuide/screens/marketplace/farmer/search_results_screen.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/screens/marketplace/farmer/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String query = '';

  Future<void> _refreshProducts(ProductProvider productProvider) async {
    await productProvider.fetchProducts();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    final isLoading = productProvider.state == ProductState.loading;
    final isError = productProvider.state == ProductState.error;
    final errorMessage = productProvider.errorMessage;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Recommendations based on the query
    final recommendations = products
        .where((product) =>
            product.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        flexibleSpace: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: LocaleData.searchProducts.getString(context),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode ? AppTheme.darkBackground : Colors.green[100],
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(query: value),
                  ),
                );
              },
            ),
            if (query.isNotEmpty && recommendations.isNotEmpty)
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final product = recommendations[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      subtitle: Text(
                        '₹${product.price}',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.green.shade700,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: product,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(productProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (isError)
                Center(child: Text('Error: $errorMessage'))
              else if (products.isEmpty)
                const Center(child: Text('No products for now'))
              else ...[
                CarouselSlider(
                  items: products.map((product) {
                    return Builder(
                      builder: (BuildContext context) {
                        return DiscountedProductCard(product: product);
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                      label: Text(LocaleData.all.getString(context)),
                      selected: false,
                      onSelected: (isSelected) {
                        // Filter functionality here
                      },
                    ),
                    ChoiceChip(
                      label: Text(LocaleData.vegies.getString(context)),
                      selected: false,
                      onSelected: (isSelected) {
                        // Filter functionality here
                      },
                    ),
                    ChoiceChip(
                      label: Text(LocaleData.fruits.getString(context)),
                      selected: false,
                      onSelected: (isSelected) {
                        // Filter functionality here
                      },
                    ),
                    ChoiceChip(
                      label: Text(LocaleData.dairy.getString(context)),
                      selected: false,
                      onSelected: (isSelected) {
                        // Filter functionality here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (query.isNotEmpty && recommendations.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.recommendations.getString(context),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100, // Adjust height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final product = recommendations[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                              product: product,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.imageUrls.isNotEmpty
                                              ? product.imageUrls[0]
                                              : '',
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: products.length, // Use filtered results
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: 260, // Set a fixed height for each grid item
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product); // Product card widget
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
