import 'package:flutter/material.dart';
import 'package:lovely_shop_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/add_product_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // 상속받은 클래스를 상태로 감싸는 작업
      create: (_) => ProductProvider(), //상태 관리를 위한
      child: const LovelyShopApp(), // 기존 사랑님 코드 그대로 유지
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
      },
    );
  }
}
