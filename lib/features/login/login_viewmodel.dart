import 'package:brainhub/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginViewModel extends ChangeNotifier {
  final _client = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Result<(), String>> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.signInWithPassword(email: email, password: password);
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

