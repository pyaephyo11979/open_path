import 'package:flutter/material.dart';
import 'package:open_path/core/services/secure_storage_service.dart';
import 'package:open_path/models/user_model.dart';
import 'package:open_path/repositories/user_api.dart';
import 'package:go_router/go_router.dart';

class UserController {
  final UserApi _userApi = UserApi();

  Future<UserModel> getUserData() async {
    return await _userApi.getUserProfile();
  }

  Future<void> logout({required BuildContext context}) async {
    bool isSuccess = await _userApi.logout();
    if (isSuccess) {
      await SecureStorageService().deleteAuthToken();
      if (context.mounted) {
        context.go('/login');
      }
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    return await _userApi.updateProfile(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<UserModel> updateProfileImage(String imagePath) async {
    return await _userApi.updateProfileImage(imagePath);
  }
}
