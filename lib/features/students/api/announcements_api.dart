import '../../../core/network/api_client.dart';

class AnnouncementApi {
  final ApiClient _client;

  AnnouncementApi(this._client);

  Future<List<dynamic>> getStudentAnnouncements() async {
    final response = await _client.getJson('/announcements/my-feed');
    return response['announcements'] as List<dynamic>? ?? [];
  }
}
