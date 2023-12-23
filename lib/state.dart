import 'package:flutter/material.dart';

//登陆状态
class LoginStatus with ChangeNotifier {
  bool _isLogin;

  LoginStatus(this._isLogin);

  bool get isLogin => _isLogin;

  set isLogin(bool islogin) {
    _isLogin = islogin;
    notifyListeners();
  }
}
