import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserModel with ChangeNotifier {
  String? _userId;

  String? _nickname;
  String? _area;
  String? _intro;

  String? get userId => _userId;
  bool get isLogin => _userId != null; // null이 아닐 경우 true return

  String? get nickname => _nickname;
  String? get area => _area;
  String? get intro => _intro;

  void setProfile(String? nickname, String? area, String? intro) {
    _nickname = nickname;
    _area = area;
    _intro = intro;
    notifyListeners();
  }
  void login(String id, String? nickname){
    _userId = id;
    _nickname = nickname;
    if (_userId != null) {
      print("사용자는 현재 로그인되어 있습니다.");
    } else {
      print("사용자는 현재 로그아웃되어 있습니다.");
    }
    notifyListeners();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (_userId != null) {
      print("사용자는 현재 로그인되어 있습니다.");
    } else {
      print("사용자는 현재 로그아웃되어 있습니다.");
    }
    _userId = null;
    _nickname = null;
    notifyListeners();
    print("로그아웃 완료");
    print("isLogin 값: $isLogin"); // 로그아웃 후 isLogin 값 확인
  }
}