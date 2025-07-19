import 'package:flutter/material.dart';
import 'package:lovely_shop_app/models/admob_banner.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

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
                onSelected: (value) {
                  if (value == 'logout') {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('로그아웃'),
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
                        // 최근 상품 영역 (메인 상품 이미지)
                        SliverToBoxAdapter(
                          //스크롤이 되기 위해서 작성해야함
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () => selectProduct(products.first),
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          products.first.imageUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
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
                                            Text(
                                              products.first.name,
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
                                              products.first.description,
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
                                              '${NumberFormat('#,###').format(products.first.price)}원',
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
          floatingActionButton: SizedBox(
            // 버튼 사이즈 키움
            width: 60,
            height: 60,
            child: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/addProduct'),
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
