import 'package:cu_plus_webapp/core/network/api_client.dart';

class NotificationsApi {
  NotificationsApi(this._client);

  final ApiClient _client;

  /// GET /student/notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final res = await _client.getJson('/student/notifications') as Map<String, dynamic>;
    return (res['notifications'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  /// GET /student/notifications/unread-count
  Future<int> getUnreadCount() async {
    final res = await _client.getJson('/student/notifications/unread-count') as Map<String, dynamic>;
    return (res['unreadCount'] ?? 0) is int
        ? res['unreadCount']
        : int.tryParse(res['unreadCount'].toString()) ?? 0;
  }

  /// PATCH /student/notifications/:id/read
  Future<void> markAsRead(String id) async {
    await _client.patchJson('/student/notifications/$id/read', {});
  }

  /// PATCH /student/notifications/read-all
  Future<void> markAllAsRead() async {
    await _client.patchJson('/student/notifications/read-all', {});
  }

  /// DELETE /student/notifications/:id
  Future<void> deleteNotification(String id) async {
    await _client.deleteJson('/student/notifications/$id');
  }

  /// DELETE /student/notifications
  Future<void> clearAllNotifications() async {
    await _client.deleteJson('/student/notifications');
  }
}