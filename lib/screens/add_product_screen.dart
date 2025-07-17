import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? imageUrl;
  String name = '';
  String description = '';
  String priceText = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (imageUrl == null || imageUrl!.isEmpty) {
        Fluttertoast.showToast(msg: '이미지를 선택해주세요');
        return;
      }

      final newProduct = Product(
        id: DateTime.now().toString(),
        name: name,
        price: int.parse(priceText),
        description: description,
        imageUrl: imageUrl!,
      );

      Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('등록 완료'),
          content: const Text('상품이 등록되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 홈화면으로 이동
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade200,
          title: const Text('상품 등록', style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade50,
                    foregroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      imageUrl = 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}';
                    });
                  },
                  child: const Text('이미지 선택'),
                ),
                const SizedBox(height: 8),
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const Text('이미지 선택됨 없음'),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '상품 이름'),
                  validator: (value) =>
                      value == null || value.isEmpty ? '필수 입력 항목입니다' : null,
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '상품 가격'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '필수 입력 항목입니다';
                    if (int.tryParse(value) == null) return '숫자만 입력하세요';
                    return null;
                  },
                  onChanged: (value) => priceText = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '상품 설명'),
                  maxLines: 5,
                  validator: (value) =>
                      value == null || value.isEmpty ? '필수 입력 항목입니다' : null,
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade100,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _submit,
                    child: const Text('등록하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
