import 'dart:developer';

import 'package:open_path/core/services/secure_storage_service.dart';
import 'package:open_path/core/services/notification_service.dart';
import 'package:open_path/models/auth_model.dart';
import 'package:open_path/core/services/api_service.dart';
import 'package:open_path/repositories/notification_api.dart';
import 'package:dio/dio.dart';
import 'package:open_path/models/user_model.dart';
import 'package:open_path/core/configs/routes/app_route.dart';

class UserApi {
  Future<void> _registerFcmToken() async {
    try {
      final fcmToken = await NotificationService().getFcmToken();
      if (fcmToken != null) {
        await NotificationRepository(APIService()).updateFcmToken(fcmToken);
        log('FCM token registered successfully');
      }
    } catch (e) {
      log('Failed to register FCM token: $e');
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final response = await APIService().post(
        url: '/auth/register',
        body: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await SecureStorageService().saveAuthToken(authModel.token);
        await _registerFcmToken();
        appRouter.go('/');
      } else {
        throw Exception('Failed to sign up');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to sign up';
      throw Exception(message);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await APIService().post(
        url: '/auth/login',
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final authModel = AuthModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await SecureStorageService().saveAuthToken(authModel.token);
        await _registerFcmToken();
        appRouter.go('/');
      } else {
        log(response.data.toString());
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      log(e.toString());
      final message = e.response?.data['message'] ?? 'Failed to login';
      throw Exception(message);
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await APIService().get(
        url: '/user/profile',
        isTokenNeed: true,
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to fetch user profile';
      throw Exception(message);
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    try {
      final response = await APIService().put(
        url: '/user/profile',
        body: {
          'name': name,
          'email': email,
          if (password != null) 'password': password,
        },
        isTokenNeed: true,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update user profile');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to update user profile';
      throw Exception(message);
    }
  }

  Future<UserModel> updateProfileImage(String imagePath) async {
    try {
      final token = await SecureStorageService().getAuthToken();
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });
      final response = await Dio().put(
        '${APIService().baseUrl}/user/profile/image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update profile image');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to update profile image';
      throw Exception(message);
    }
  }

  Future<bool> logout() async {
    try {
      final response = await APIService().post(
        url: '/auth/logout',
        body: {},
        isTokenNeed: true,
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to logout';
      throw Exception(message);
    }
  }
}
