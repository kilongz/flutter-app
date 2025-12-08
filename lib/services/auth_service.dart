import 'dart:convert';
import 'package:lotapp/services/variables.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //for logins
  static Future<Map<String, dynamic>?> login(
    String credential,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$apiURL/students-login'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"credential": credential, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data;
    } else {
      return null;
    }
  }

  //for registers
  static Future<bool> register(
    String name,
    String username,
    String email,
    String password,
    String passwordConfirmation,
    String lrn,
    String gradeLevel,
    String section,
    String cpnumber,
  ) async {
    final response = await http.post(
      Uri.parse('$apiURL/students-register'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "username": username,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "lrn": lrn,
        "grade_level": gradeLevel,
        "section": section,
        "cpnumber": cpnumber,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
