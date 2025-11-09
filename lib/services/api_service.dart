import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _base = 'https://openlibrary.org/search.json?q=';

  static Future<List<Book>> searchBooks(String query) async {
    final encoded = Uri.encodeQueryComponent(query.trim());
    final url = Uri.parse('$_base$encoded');

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['docs'] == null || data['docs'] is! List) {
        return [];
      }

      final docs = data['docs'] as List;
      final books = docs.map((doc) {
        return Book.fromJson(doc as Map<String, dynamic>);
      }).toList();

      return books;
    } catch (e) {
      // Repassa a exceção para o caller tratar
      throw Exception('Falha ao buscar livros: $e');
    }
  }
}
