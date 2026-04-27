import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoadingLogin = false;
  bool _isLoadingRegister = false;
  LoginViewModel();

  bool get isLoadingLogin => _isLoadingLogin;
  bool get isLoadingRegister => _isLoadingRegister;
  bool get isLoading => _isLoadingRegister || _isLoadingLogin;

  Future<Result<(), String>> login({required String email, required String password}) async {
    _isLoadingLogin = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoadingLogin = false;
    notifyListeners();

    if(email == 'exemplo@email.com' && password == 'senha123') {
      return Result.ok(());
    } else {
      return Result.err('Invalid email or password');
    }
  }

  Future<Result<(), String>> register({required String email, required String password}) async {
    _isLoadingRegister = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoadingRegister = false;
    notifyListeners();
    if(email.isEmpty) {
      return Result.err('Invalid email');
    } else if(password.isEmpty) {
      return Result.err('Invalid password');
    } else {
      return Result.ok(());
    }
  }
}
