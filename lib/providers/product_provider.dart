import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: '리본 티셔츠',
      price: 16000,
      description: '사랑스러운 리본 티셔츠입니다.',
      imageUrl: 'https://picsum.photos/200/300?1',
    ),
    Product(
      id: '2',
      name: '플라워 원피스',
      price: 32000,
      description: '화사한 플라워 패턴의 원피스입니다.',
      imageUrl: 'https://picsum.photos/200/300?2',
    ),
  ];

  List<Product> get products => List.unmodifiable(_products); // 읽기 전용

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners(); // UI에 변경 알림
  }
}
