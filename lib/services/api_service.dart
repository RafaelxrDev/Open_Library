import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _searchBase = 'https://openlibrary.org/search.json?q=';

  static Future<List<Book>> searchBooks(String query) async {
    final encoded = Uri.encodeQueryComponent(query.trim());
    final uri = Uri.parse('$_searchBase$encoded');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['docs'] == null || data['docs'] is! List) return [];

      final docs = data['docs'] as List;
      final books = docs.map((d) => Book.fromJson(d as Map<String, dynamic>)).toList();
      return books;
    } catch (e) {
      throw Exception('Falha ao buscar livros: $e');
    }
  }

  
  static Future<Map<String, dynamic>> fetchBookDetails(String workKey) async {
    final uri = Uri.parse('https://openlibrary.org$workKey.json');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw Exception('Erro ao carregar detalhes: ${response.statusCode}');
      }
      final Map<String, dynamic> map = jsonDecode(response.body);
      return map;
    } catch (e) {
      throw Exception('Falha ao carregar detalhes: $e');
    }
  }
}
