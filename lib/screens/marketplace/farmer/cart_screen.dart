import 'package:AgriGuide/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/providers/product_provider.dart';
import 'package:AgriGuide/screens/marketplace/farmer/product_detail_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProducts = productProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.myCart.getString(context)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          ),
        ),
      ),
      body: cartProducts.isEmpty
          ? Center(child: Text(LocaleData.yourCartEmpty.getString(context)))
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return GestureDetector(
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10)),
                          child: Image.network(
                            product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
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
                                  '₹${product.price}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14, // Smaller font size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_shopping_cart),
                          onPressed: () {
                            productProvider.removeFromCart(product.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocaleData.removedFromCart.getString(context)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₹${cartProducts.fold(0, (sum, item) => sum + item.price.toInt())}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Functionality to proceed to checkout
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleData.proceed.getString(context)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green.shade600,
                backgroundColor: Colors.white,
              ),
              child: Text(LocaleData.checkout.getString(context)),
            ),
          ],
        ),
      ),
    );
  }
}
