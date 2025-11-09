import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  Future<Map<String, dynamic>> getBookDetails(String workKey) async {
    try {
      final response = await http.get(
        Uri.parse('https://openlibrary.org$workKey.json'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar detalhes do livro');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
