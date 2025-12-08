import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotapp/models/borrow_status.dart';
import 'package:lotapp/services/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BorrowService {
  Future<List<BorrowStatus>> getBorrowRequests(int studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$apiURL/borrow-requests/$studentId"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'];

      return list.map((e) => BorrowStatus.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load borrow requests");
    }
  }

  Future<bool> borrowItem(int itemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final studentId = prefs.getInt('student_id');

      final response = await http.post(
        Uri.parse('$apiURL/borrow-requests'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"student_id": studentId, "item_id": itemId}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final err = jsonDecode(response.body);
        print(err['message']);
        return false;
      }
    } catch (e) {
      print("an error occured while trying to request a borrow...");
      return false;
    }
  }
}
