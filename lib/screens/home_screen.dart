import 'package:flutter/material.dart';
import 'package:lovely_shop_app/models/admob_banner.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/image_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void selectProduct(Product product) {
    Navigator.pushNamed(
      context,
      '/productDetail',
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    // 1번 상품만 메인에 표시
    final mainProduct = products.where((p) => p.id == 'product_1').isNotEmpty
        ? products.firstWhere((p) => p.id == 'product_1')
        : (products.isNotEmpty ? products.first : null);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Scaffold(
          appBar: AppBar(
            title: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Row(
                  children: [
                    const Text('Lovely Shop'),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: authProvider.isAdmin
                            ? Colors.red[100]
                            : Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        authProvider.isAdmin ? '관리자' : '고객',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: authProvider.isAdmin
                              ? Colors.red[700]
                              : Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              // 관리자만 상품 등록 버튼 표시
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.isAdmin) {
                    return IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: '상품 등록',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/addProduct'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Consumer<CartProvider>(
                builder: (ctx, cart, child) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // 로그아웃 버튼
              PopupMenuButton<String>(
                tooltip: '전환',
                onSelected: (value) {
                  if (value == 'change') {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'change',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.red),
                        SizedBox(width: 8),
                        Text('전환', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(children: [
            const AdmobBanner(),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('상품이 없습니다.'))
                  : CustomScrollView(
                      slivers: [
                        // 메인 상품 영역 (1번 상품만)
                        if (mainProduct != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () => selectProduct(mainProduct),
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withAlpha(30),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    // 메인 사진 위에 글자들을 스텍으로 쌓음
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: ImageUtils.buildImage(
                                              mainProduct.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withAlpha(30),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 16,
                                          bottom: 16,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // 50% 세일 배지
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: const Text(
                                                  '50% SALE',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                mainProduct.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(1, 1),
                                                      blurRadius: 3,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                mainProduct.description,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(1, 1),
                                                      blurRadius: 3,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${NumberFormat('#,###').format(mainProduct.price)}원',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(1, 1),
                                                      blurRadius: 3,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // 상품 목록
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  return ProductCard(
                                    product: products[index],
                                    onTap: () => selectProduct(products[index]),
                                    onEdit: authProvider.isAdmin
                                        ? () => Navigator.pushNamed(
                                              context,
                                              '/addProduct',
                                              arguments: products[index],
                                            )
                                        : null,
                                  );
                                },
                              );
                            },
                            childCount: products.length,
                          ),
                        ),
                      ],
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}
