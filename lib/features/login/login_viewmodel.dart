class LoginViewModel {
  const LoginViewModel();

  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    return email == 'exemplo@email.com' && password == 'senha123';
  }

  Future<bool> register({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    return email.isNotEmpty && password.isNotEmpty;
  }
}
