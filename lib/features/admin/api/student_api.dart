import '../../../core/network/api_client.dart';

class StudentApi {
  final ApiClient _client;

  StudentApi(this._client);

  Future<void> createStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String schoolId,
    required String year,
  }) async {
    final response = await _client.postJson(
      '/admin/students',
      {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "schoolId": schoolId,
        "year": year,
      },
    );

    if (response.isEmpty) {
      throw Exception("Failed to create student");
    }
  }

  Future<List<StudentRow>> getStudents() async {
    final response = await _client.getJson('/admin/students');
    final students = response['students'] as List<dynamic>? ?? [];

    return students
        .map(
          (item) => StudentRow.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}

class StudentRow {
  final String id;
  final String schoolId;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String year;
  final String role;

  const StudentRow({
    required this.id,
    required this.schoolId,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.year,
    required this.role,
  });

  factory StudentRow.fromJson(Map<String, dynamic> json) {
    final firstName = (json['firstName'] ?? '').toString();
    final lastName = (json['lastName'] ?? '').toString();

    return StudentRow(
      id: (json['id'] ?? '').toString(),
      schoolId: (json['schoolId'] ?? '').toString(),
      firstName: firstName,
      lastName: lastName,
      name: (json['name'] ?? '$firstName $lastName').toString(),
      email: (json['email'] ?? '').toString(),
      year: (json['year'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
    );
  }
}