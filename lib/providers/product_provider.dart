import 'dart:convert';
import 'package:AgriGuide/models/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:AgriGuide/models/product.dart';
import 'package:AgriGuide/utils/constants.dart';

enum ProductState { idle, loading, success, error }

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  Vendor? _vendorDetails;
  List<Product> _favoriteProducts = [];
  List<Product> _cartItems = [];
  final storage = const FlutterSecureStorage();

  ProductState _state = ProductState.idle;
  String _errorMessage = '';

  List<Product> get products => _products;
  Vendor? get vendorDetails => _vendorDetails;
  List<Product> get favoriteProducts => [..._favoriteProducts];
  List<Product> get cartItems => [..._cartItems];
  ProductState get state => _state;
  String get errorMessage => _errorMessage;

  void _setState(ProductState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchVendorDetails(String vendorId) async {
    _setState(ProductState.loading);
    _errorMessage = '';

    try {
      final response =
          await http.get(Uri.parse('$baseUrl/marketplace/$vendorId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print("api data: $data");
        _vendorDetails = Vendor.fromJson(data);
        _setState(ProductState.success);
      } else {
        _errorMessage = 'Failed to load vendor details';
        _setState(ProductState.error);
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> fetchProducts() async {
    _setState(ProductState.loading);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/marketplace'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        _products = data.map((json) => Product.fromJson(json)).toList();
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> addProduct(Product product) async {
    _setState(ProductState.loading);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/marketplace'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 201) {
        _products.add(Product.fromJson(json.decode(response.body)));
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to add product');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    _setState(ProductState.loading);
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedProduct.toJson()),
      );
      if (response.statusCode == 200) {
        final index = _products.indexWhere((product) => product.id == id);
        if (index != -1) {
          _products[index] = Product.fromJson(json.decode(response.body));
          _setState(ProductState.success);
        } else {
          throw Exception('Product not found');
        }
      } else {
        throw Exception('Failed to update product');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> deleteProduct(String id) async {
    _setState(ProductState.loading);
    try {
      final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        _products.removeWhere((product) => product.id == id);
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> searchProducts(String query) async {
    _setState(ProductState.loading);
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/products/search?q=$query'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to search products');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> addToCart(Product product) async {
    _setState(ProductState.loading);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 200) {
        _cartItems.add(product);
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> removeFromCart(String productId) async {
    _setState(ProductState.loading);
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/cart/remove/$productId'));
      if (response.statusCode == 200) {
        _cartItems.removeWhere((item) => item.id == productId);
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to remove from cart');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> clearCart() async {
    _setState(ProductState.loading);
    try {
      final response = await http.delete(Uri.parse('$baseUrl/cart/clear'));
      if (response.statusCode == 200) {
        _cartItems.clear();
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to clear cart');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }

  Future<void> toggleFavorite(String productId) async {
    _setState(ProductState.loading);
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/favorite/toggle/$productId'));
      if (response.statusCode == 200) {
        final isFavorite =
            _favoriteProducts.any((item) => item.id == productId);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isFavorite) {
            _favoriteProducts.removeWhere((item) => item.id == productId);
          } else {
            final product = _products.firstWhere(
              (item) => item.id == productId,
              orElse: () => throw Exception('Product not found'),
            );
            _favoriteProducts.add(product);
          }
          notifyListeners();
        });
        _setState(ProductState.success);
      } else {
        throw Exception('Failed to toggle favorite');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _setState(ProductState.error);
    }
  }
}
