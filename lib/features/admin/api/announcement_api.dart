import '../../../core/network/api_client.dart';

class AnnouncementApi {
  final ApiClient _client;

  AnnouncementApi(this._client);

  // CREATE
  Future<void> createAnnouncement({
    required String message,
    required bool everyone,
    required bool firstYear,
    required bool secondYear,
    required bool thirdYear,
    required bool fourthYear,
  }) async {
    final response = await _client.postJson(
      '/admin/announcements',
      {
        "message": message,
        "everyone": everyone,
        "firstYear": firstYear,
        "secondYear": secondYear,
        "thirdYear": thirdYear,
        "fourthYear": fourthYear,
      },
    );

    if (response == null) {
      throw Exception("Failed to create announcement");
    }
  }

  // GET ALL
  Future<List<dynamic>> getAnnouncements() async {
    final response = await _client.getJson(
      '/admin/announcements',
    );

    if (response == null || response['announcements'] == null) {
      throw Exception("Failed to fetch announcements");
    }

    return response['announcements'];
  }

  // DELETE
  Future<void> deleteAnnouncement(String id) async {
    final response = await _client.deleteJson(
      '/admin/announcements/$id',
    );

    if (response == null) {
      throw Exception("Failed to delete announcement");
    }
  }
}