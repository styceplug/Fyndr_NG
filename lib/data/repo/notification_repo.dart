import 'package:get/get.dart';
import '../api/api_client.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  Future<Response> getNotifications({int page = 1, int limit = 20}) async {
    return await apiClient.getData(
      '/api/v1/notification?page=$page&limit=$limit',
    );
  }

  Future<Response> getUnreadCount() async {
    return await apiClient.getData('/api/v1/notification/unread-count');
  }

  Future<Response> markAllRead() async {
    return await apiClient.patchData('/api/v1/notification/read-all', {});
  }

  Future<Response> markOneRead(String notificationId) async {
    return await apiClient.patchData(
      '/api/v1/notification/$notificationId/read',
      {},
    );
  }
}
