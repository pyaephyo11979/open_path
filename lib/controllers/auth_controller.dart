import 'package:open_path/repositories/user_api.dart';

class AuthController {
  final UserApi _userApi = UserApi();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _userApi.signUp(name, email, password);
  }

  Future<void> login({required String email, required String password}) async {
    await _userApi.login(email, password);
  }
}
