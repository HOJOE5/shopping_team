import 'package:flutter/material.dart';
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
  Product? existingProduct;
  bool isEditMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Product) {
      existingProduct = args;
      isEditMode = true;
      imageUrl = existingProduct!.imageUrl;
      name = existingProduct!.name;
      description = existingProduct!.description;
      priceText = existingProduct!.price.toString();
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (imageUrl == null || imageUrl!.isEmpty) {
        Fluttertoast.showToast(msg: '이미지를 선택해주세요');
        return;
      }

      if (isEditMode) {
        final updatedProduct = Product(
          id: existingProduct!.id,
          name: name,
          price: int.parse(priceText),
          description: description,
          imageUrl: imageUrl!,
        );

        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(updatedProduct);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('수정 완료'),
            content: const Text('상품이 수정되었습니다.'),
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
      } else {
        final newProduct = Product(
          id: DateTime.now().toString(),
          name: name,
          price: int.parse(priceText),
          description: description,
          imageUrl: imageUrl!,
        );

        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(newProduct);

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(isEditMode ? '상품 수정' : '상품 등록',
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      imageUrl =
                          'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}';
                    });
                  },
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: imageUrl != null
                            ? Colors.transparent
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image 선택',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '상품 이름'),
                  initialValue: name,
                  validator: (value) =>
                      value == null || value.isEmpty ? '필수 입력 항목입니다' : null,
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: '상품 가격'),
                  initialValue: priceText,
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
                  initialValue: description,
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
                    child: Text(isEditMode ? '수정하기' : '등록하기'),
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
