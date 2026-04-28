import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  RegisterViewModel();

  bool get isLoading => _isLoading;

  Future<Result<(), String>> register({required String email, required String password}) async {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    if(!emailRegex.hasMatch(email)) {
      return Result.err('Invalid email');
    } else if(password.length < 6) {
      return Result.err('Password must be at least 6 characters');
    } else {
      return Result.ok(());
    }
  }
}
