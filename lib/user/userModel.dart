import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String? _userId;
  String? _nickname;

  String? get userId => _userId;
  bool get isLogin => _userId != null; // null이 아닐 경우 true return

  String? get nickname => _nickname;

  void setNickname(String? nickname) {
    _nickname = nickname;
    notifyListeners();
  }
  void login(String id, String? nickname){
    _userId = id;
    _nickname = nickname;
    notifyListeners();
  }

  void logout(){
    _userId = null;
    notifyListeners();
  }
}