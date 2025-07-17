import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Product? selectedProduct;

  void selectProduct(Product product) {
    setState(() {
      selectedProduct = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Lovely Shop')),
        body: Row(
          children: [
            // 왼쪽 상품 목록
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: products.isEmpty
                        ? const Center(child: Text('상품이 없습니다.'))
                        : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: products[index],
                                onTap: () => selectProduct(products[index]),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // 오른쪽 선택된 상품 표시 영역
            Expanded(
              child: selectedProduct == null
                  ? const Center(child: Text('선택된 상품이 없습니다.'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedProduct!.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          Text('${selectedProduct!.price}원'),
                          const SizedBox(height: 12),
                          Image.network(
                            selectedProduct!.imageUrl,
                            height: 150,
                          ),
                          const SizedBox(height: 12),
                          Text(selectedProduct!.description),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/addProduct'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
