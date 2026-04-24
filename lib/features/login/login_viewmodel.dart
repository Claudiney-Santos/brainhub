import 'package:brainhub/utils/result.dart';

class LoginViewModel {
  const LoginViewModel();

  Future<Result<(), String>> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if(email == 'exemplo@email.com' && password == 'senha123') {
      return Result.ok(());
    } else {
      return Result.err('Invalid email or password');
    }
  }

  Future<Result<(), String>> register({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if(email.isEmpty) {
      return Result.err('Invalid email');
    } else if(password.isEmpty) {
      return Result.err('Invalid password');
    } else {
      return Result.ok(());
    }
  }
}
