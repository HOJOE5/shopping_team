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
      // 기존 저장된 데이터 삭제 (한글 파일명 문제 해결)
      await _storageService.clearProducts();

      _products.clear();
      // 항상 기본 상품들로 새로 초기화
      await _initializeDefaultProducts();

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('상품 로드 실패: $e');
      // 로드 실패 시에도 기본 상품들 추가
      await _initializeDefaultProducts();
      _isLoaded = true;
      notifyListeners();
    }
  }

  // 기본 상품들을 초기화
  Future<void> _initializeDefaultProducts() async {
    final defaultProducts = [
      Product(
        id: 'product_1',
        name: '핑크 로즈 블라우스',
        description:
            '부드러운 실크 소재의 로맨틱한 핑크 블라우스입니다. 데이트룩이나 오피스룩 모두에 완벽하게 어울리는 아이템이에요.',
        price: 45000,
        imageUrl: 'assets/product1.jpg',
      ),
      Product(
        id: 'product_2',
        name: '베이지 트렌치 코트',
        description:
            '클래식한 디자인의 베이지 트렌치 코트입니다. 봄, 가을 시즌 필수 아우터로 어떤 스타일링에도 세련되게 매치됩니다.',
        price: 89000,
        imageUrl: 'assets/product2.jpg',
      ),
      Product(
        id: 'product_3',
        name: '화이트 코튼 셔츠',
        description: '깔끔한 화이트 코튼 셔츠로 기본템 중의 기본템입니다. 어떤 바텀과도 잘 어울리는 만능 아이템이에요.',
        price: 32000,
        imageUrl: 'assets/product3.jpg',
      ),
      Product(
        id: 'product_4',
        name: '데님 자켓',
        description:
            '빈티지한 느낌의 데님 자켓입니다. 캐주얼한 스타일링에 완벽하게 어울리는 아이템으로 사계절 착용 가능합니다.',
        price: 67000,
        imageUrl: 'assets/product4.jpg',
      ),
      Product(
        id: 'product_5',
        name: '플로럴 원피스',
        description: '여성스러운 플로럴 패턴의 원피스입니다. 봄, 여름 시즌에 완벽한 로맨틱한 룩을 연출할 수 있어요.',
        price: 54000,
        imageUrl: 'assets/product5.jpg',
      ),
    ];

    _products.addAll(defaultProducts);
    await _storageService.saveProducts(_products);
  }

  Future<void> addProduct(Product product) async {
    _products.insert(0, product); // 맨 앞에 추가하여 최신 상품이 첫 번째가 되도록
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
