import '../../../core/network/api_client.dart';

class AnnouncementApi {
  final ApiClient _client;

  AnnouncementApi(this._client);

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
}