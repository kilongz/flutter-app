import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotapp/services/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

class ApiService {
  Future<Map<String, dynamic>?> getItems(int page) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$apiURL/items?page=$page'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<Item> items = (data['items']['data'] as List)
            .map((i) => Item.fromJson(i))
            .toList();

        return {
          "items": items,
          "nextPage": data['items']['next_page_url'] != null ? page + 1 : null,
        };
      } else {
        print("API ERROR: ${response.body}");
        return null;
      }
    } catch (e) {
      print("an error occured...");
      return null;
    }
  }
}
