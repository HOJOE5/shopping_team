import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  final StorageService _storageService = StorageService();
  bool _isLoaded = false;

  List<Product> get products => List.unmodifiable(_products); // 읽기 전용

  // 앱 시작시 저장된 상품들을 로드
  Future<void> loadProducts() async {
    if (_isLoaded) return; // 이미 로드된 경우 중복 로드 방지

    try {
      final loadedProducts = await _storageService.loadProducts();
      _products.clear();
      _products.addAll(loadedProducts);
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('상품 로드 실패: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _storageService.saveProducts(_products);
    notifyListeners(); // UI에 변경 알림
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index =
        _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index >= 0) {
      _products[index] = updatedProduct;
      await _storageService.saveProducts(_products);
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
    await _storageService.saveProducts(_products);
    notifyListeners();
  }
}
