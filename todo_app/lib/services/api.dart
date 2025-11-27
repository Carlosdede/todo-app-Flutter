import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';

class Api {
  static const baseUrl = "https://todo-app-flutter.onrender.com/api";

  /// POST genérico com debug
  static Future<Map<String, dynamic>> post(String endpoint, Map body) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    print("➡️ POST: $url");
    print("➡️ BODY: $body");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("⬅️ STATUS: ${res.statusCode}");
      print("⬅️ RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("Erro HTTP ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      print("❌ ERRO NA REQUISIÇÃO POST: $e");
      rethrow;
    }
  }

  /// GET todos
  static Future<List<dynamic>> getTodos() async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos");

    print("➡️ GET: $url");
    print("➡️ TOKEN: $token");

    try {
      final res = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("⬅️ STATUS: ${res.statusCode}");
      print("⬅️ RESPONSE: ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("Erro HTTP ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      print("❌ ERRO NO GET TODOS: $e");
      rethrow;
    }
  }

  /// Criar Todo
  static Future createTodo(String title) async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos");

    print("➡️ CREATE TODO: $title");

    try {
      final res = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"title": title}),
      );

      print("⬅️ STATUS: ${res.statusCode}");
      print("⬅️ RESPONSE: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception("Erro ao criar Todo ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      print("❌ ERRO AO CRIAR TODO: $e");
      rethrow;
    }
  }

  /// Alternar Todo
  static Future toggleTodo(int id) async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos/$id/toggle");

    print("➡️ TOGGLE TODO: $id");

    try {
      final res = await http.put(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("⬅️ STATUS: ${res.statusCode}");
      print("⬅️ RESPONSE: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception("Erro ao alternar Todo ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      print("❌ ERRO NO TOGGLE TODO: $e");
      rethrow;
    }
  }

  /// Excluir Todo
  static Future deleteTodo(int id) async {
    final token = await SecureStorage.getToken();
    final url = Uri.parse("$baseUrl/todos/$id");

    print("➡️ DELETE TODO: $id");

    try {
      final res = await http.delete(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      print("⬅️ STATUS: ${res.statusCode}");
      print("⬅️ RESPONSE: ${res.body}");

      if (res.statusCode != 200) {
        throw Exception("Erro ao deletar Todo ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      print("❌ ERRO AO DELETAR TODO: $e");
      rethrow;
    }
  }
}
