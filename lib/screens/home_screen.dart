import 'package:flutter/material.dart';
import 'package:lovely_shop_app/models/admob_banner.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

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
            title: const Text('Lovely Shop'),
            actions: [
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
            ],
          ),
          body: Column(children: [
            const AdmobBanner(),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('상품이 없습니다.'))
                  : CustomScrollView(
                      slivers: [
                        // 최근 상품 영역
                        SliverToBoxAdapter(
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
                              return ProductCard(
                                product: products[index],
                                onTap: () => selectProduct(products[index]),
                                onEdit: () => Navigator.pushNamed(
                                  context,
                                  '/addProduct',
                                  arguments: products[index],
                                ),
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
