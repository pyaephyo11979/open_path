import 'dart:developer';

import 'package:open_path/core/services/api_service.dart';

class NotificationRepository {
  final APIService _apiService;

  NotificationRepository(this._apiService);

  Future<void> updateFcmToken(String fcmToken) async {
    log(fcmToken);
    await _apiService.put(
      url: '/user/fcm-token',
      body: {'fcmToken': fcmToken},
      isTokenNeed: true,
    );
  }
}
