import 'package:flutter/material.dart';
import 'package:gemicates_test/services/api_services.dart';
import 'package:gemicates_test/services/firebase_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/product_model.dart';

class ProductController extends ChangeNotifier {
  final Ref ref;
  ProductController(this.ref);
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _products = [];
  bool _showDiscountedPrice = false;
  bool isLoading = false;

  List<Product> get products => _products;
  bool get showDiscountedPrice => _showDiscountedPrice;

  Future<void> fetchProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      _products = await _apiService.fetchProducts();
      await _fetchRemoteConfig();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchRemoteConfig() async {
    try {
      _showDiscountedPrice = await _firebaseService.getShowDiscountedPrice();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch remote config: $e');
    }
  }

  double getDisplayPrice(Product product) {
    if (_showDiscountedPrice) {
      return (product.price ?? 0) * (1 - (product.discountPercentage ?? 0) / 100);
    }
    return (product.price ?? 0);
  }
}

final productController = ChangeNotifierProvider((ref) => ProductController(ref));
