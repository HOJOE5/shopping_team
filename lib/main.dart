import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/add_product_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LovelyShopApp());
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
      },
    );
  }
}
