import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';

class Api {
  static const baseUrl = "https://todo-app-flutter.onrender.com/api"; 

  static Future<Map<String, dynamic>> post(String endpoint, Map body) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getTodos() async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  static Future createTodo(String title) async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos");

    await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"title": title}),
    );
  }

  static Future toggleTodo(int id) async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos/$id/toggle");

    await http.put(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  static Future deleteTodo(int id) async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos/$id");

    await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
