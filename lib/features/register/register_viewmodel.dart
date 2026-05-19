import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterViewModel extends ChangeNotifier {
  final _client = Supabase.instance.client;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Result<(), String>> register({
    required String email,
    required String password,
  }) async {
    if (!_emailRegex.hasMatch(email)) {
      return Result.err('Invalid email');
    }
    if (password.length < 6) {
      return Result.err('Password must be at least 6 characters');
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.signUp(email: email, password: password);
      return Result.ok(());
    } on AuthException catch (e) {
      return Result.err(e.message);
    } catch (e) {
      return Result.err('Unexpected error. Try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

