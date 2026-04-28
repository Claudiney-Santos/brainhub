import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  LoginViewModel();

  bool get isLoading => _isLoading;

  Future<Result<(), String>> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    if(email == 'exemplo@email.com' && password == 'senha123') {
      return Result.ok(());
    } else {
      return Result.err('Invalid email or password');
    }
  }
}
