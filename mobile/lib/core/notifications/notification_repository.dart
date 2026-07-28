import '../network/api_client.dart';

/// Sends this device's FCM token to the backend so it can push
/// notifications (complaint status updates, hearing dates, etc.) to the
/// citizen identified by [mobile].
class NotificationRepository {
  const NotificationRepository();

  Future<void> registerToken({required String mobile, required String token}) async {
    await ApiClient.instance.post<Map<String, dynamic>>(
      '/api/v1/notifications/register-token',
      data: {'mobile': mobile, 'token': token, 'platform': 'android'},
    );
  }
}
