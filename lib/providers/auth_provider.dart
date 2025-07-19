import 'package:flutter/foundation.dart';

enum UserType { customer, admin }

class User {
  final String id;
  final String name;
  final UserType type;

  User({
    required this.id,
    required this.name,
    required this.type,
  });
}

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _currentUser?.type == UserType.admin;
  bool get isCustomer => _currentUser?.type == UserType.customer;

  // 미리 정의된 사용자 계정 (실제 앱에서는 서버에서 관리)
  final Map<String, Map<String, dynamic>> _users = {
    'admin': {
      'name': '관리자',
      'type': UserType.admin,
    },
    'customer': {
      'name': '고객',
      'type': UserType.customer,
    },
  };

  Future<bool> login(String userType) async {
    // 실제 앱에서는 서버 API 호출
    if (_users.containsKey(userType)) {
      _currentUser = User(
        id: userType,
        name: _users[userType]!['name'],
        type: _users[userType]!['type'],
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // 관리자 권한 체크
  bool checkAdminPermission() {
    return isLoggedIn && isAdmin;
  }
}
