import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_suitmedia/models/user_models.dart';

/// Service untuk mengambil data pengguna dari API
class UserService {
  static const String baseUrl = 'https://reqres.in/api';

  static Future<UserResponse> fetchUsers(int page, int perPage) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users?page=$page&per_page=$perPage'),
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return UserResponse(
          data: [],
          page: page,
          perPage: perPage,
          total: 0,
          totalPages: page - 1, 
        );
      } else {
        throw Exception('Gagal memuat pengguna: ${response.statusCode}');
      }
    } catch (e) {
      return UserResponse(
        data: [],
        page: page,
        perPage: perPage,
        total: 0,
        totalPages: page > 1 ? page - 1 : 1,
      );
    }
  }
}