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
      child: Scaffold(
        appBar: AppBar(title: const Text('Lovely Shop')),
        body: products.isEmpty
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/addProduct'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
