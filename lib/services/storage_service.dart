import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class StorageService {
  static const String _fileName = 'products.json';

  // 앱 문서 디렉토리 경로 얻기
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 상품 파일 참조 얻기
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  // 상품 목록을 JSON 파일에 저장
  Future<void> saveProducts(List<Product> products) async {
    try {
      final file = await _localFile;
      final jsonList = products.map((product) => product.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('상품 저장 중 오류 발생: $e');
    }
  }

  // JSON 파일에서 상품 목록 읽기
  Future<List<Product>> loadProducts() async {
    try {
      final file = await _localFile;

      // 파일이 존재하지 않으면 빈 리스트 반환
      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('상품 로드 중 오류 발생: $e');
      return [];
    }
  }

  // 파일 삭제 (필요시 사용)
  Future<void> clearProducts() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('상품 데이터 삭제 중 오류 발생: $e');
    }
  }
}
