import 'package:dio/dio.dart';
import 'package:open_path/core/services/secure_storage_service.dart';
import 'package:open_path/core/configs/routes/app_route.dart';

class APIService {
  final Dio dio = Dio();
  final String baseUrl = 'https://mxs008p0-3001.asse.devtunnels.ms/api';

  Map<String, dynamic> defaultHeader = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<void> getToken() async {
    final token = await SecureStorageService().getAuthToken();
    if (token != null && token.isNotEmpty) {
      defaultHeader.addAll({"Authorization": "Bearer $token"});
    }
  }

  Future<Response> get({required String url, bool? isTokenNeed}) async {
    if (isTokenNeed == true) {
      await getToken();
    }

    final Response fetchedData = await dio.get(
      "$baseUrl$url",
      options: Options(headers: defaultHeader),
    );

    if (fetchedData.statusCode == 401) {
      bool success = await getRefreshToken(
        url: '/auth/refresh',
        body: {},
        isTokenNeed: true,
      );
      if (success) {
        await getToken();
        final Response retryResponse = await dio.get(
          "$baseUrl$url",
          options: Options(headers: defaultHeader),
        );
        return retryResponse;
      }
      appRouter.go('/login');
    }
    return fetchedData;
  }

  Future<Response> post({
    required String url,
    required Map<String, dynamic> body,
    bool? isTokenNeed,
  }) async {
    if (isTokenNeed == true) {
      await getToken();
    }
    final Response fetchedData = await dio.post(
      "$baseUrl$url",
      options: Options(headers: defaultHeader),
      data: body,
    );
    if (fetchedData.statusCode == 401) {
      bool success = await getRefreshToken(
        url: '/auth/refresh',
        body: {},
        isTokenNeed: true,
      );
      if (success) {
        await getToken();
        final Response retryResponse = await dio.post(
          "$baseUrl$url",
          options: Options(headers: defaultHeader),
          data: body,
        );
        return retryResponse;
      }
      appRouter.go('/login');
    }
    return fetchedData;
  }

  Future<Response> put({
    required String url,
    required Map<String, dynamic> body,
    bool? isTokenNeed,
  }) async {
    if (isTokenNeed == true) {
      await getToken();
    }
    final Response fetchedData = await dio.put(
      "$baseUrl$url",
      options: Options(headers: defaultHeader),
      data: body,
    );
    if (fetchedData.statusCode == 401) {
      bool success = await getRefreshToken(
        url: '/auth/refresh',
        body: {},
        isTokenNeed: true,
      );
      if (success) {
        await getToken();
        final Response retryResponse = await dio.put(
          "$baseUrl$url",
          options: Options(headers: defaultHeader),
          data: body,
        );
        return retryResponse;
      }
      appRouter.go('/login');
    }
    return fetchedData;
  }

  Future<Response> patch({
    required String url,
    required Map<String, dynamic> body,
    bool? isTokenNeed,
  }) async {
    if (isTokenNeed == true) {
      await getToken();
    }
    final Response fetchedData = await dio.patch(
      "$baseUrl$url",
      options: Options(headers: defaultHeader),
      data: body,
    );
    if (fetchedData.statusCode == 401) {
      bool success = await getRefreshToken(
        url: '/auth/refresh',
        body: {},
        isTokenNeed: true,
      );
      if (success) {
        await getToken();
        final Response retryResponse = await dio.patch(
          "$baseUrl$url",
          options: Options(headers: defaultHeader),
          data: body,
        );
        return retryResponse;
      }
      appRouter.go('/login');
    }
    return fetchedData;
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? body,
    bool? isTokenNeed,
  }) async {
    if (isTokenNeed == true) {
      await getToken();
    }
    final Response fetchedData = await dio.delete(
      "$baseUrl$url",
      options: Options(headers: defaultHeader),
      data: body,
    );
    if (fetchedData.statusCode == 401) {
      bool success = await getRefreshToken(
        url: '/auth/refresh',
        body: {},
        isTokenNeed: true,
      );
      if (success) {
        await getToken();
        final Response retryResponse = await dio.delete(
          "$baseUrl$url",
          options: Options(headers: defaultHeader),
          data: body,
        );
        return retryResponse;
      }
      appRouter.go('/login');
    }
    return fetchedData;
  }

  Future<bool> getRefreshToken({
    required String url,
    required Map<String, dynamic> body,
    bool? isTokenNeed,
  }) async {
    if (isTokenNeed == true) {
      await getToken();
    }
    await SecureStorageService().deleteAuthToken();
    final Response fetchedData = await dio.post(
      "$baseUrl$url",
      options: Options(headers: defaultHeader),
      data: body,
    );
    if (fetchedData.statusCode == 200) {
      final newToken = fetchedData.data['token'];
      await SecureStorageService().saveAuthToken(newToken);
      return true;
    }
    return false;
  }
}
