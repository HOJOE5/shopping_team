import 'package:flutter/material.dart';
import 'package:lovely_shop_app/providers/product_provider.dart';
import 'package:lovely_shop_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/cart_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const LovelyShopApp(),
    ),
  );
}

class LovelyShopApp extends StatelessWidget {
  const LovelyShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lovely Shop',
      theme: AppTheme.lovelyTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/productDetail': (context) => const ProductDetailScreen(),
        '/addProduct': (context) => const AddProductScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
