import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> postJson(String url, Map<String, dynamic> body) async {
    final res = await _client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {};
    }

    final msg = (decoded is Map && decoded["message"] != null)
        ? decoded["message"].toString()
        : "Request failed (${res.statusCode})";
    throw Exception(msg);
  }
}