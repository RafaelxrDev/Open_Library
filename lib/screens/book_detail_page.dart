import 'package:flutter/material.dart';
import '../services/book_service.dart';

class BookDetailsPage extends StatefulWidget {
  final String workKey;

  const BookDetailsPage({super.key, required this.workKey});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  final _bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Livro'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bookService.getBookDetails(widget.workKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar detalhes do livro.',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final data = snapshot.data ?? {};
          final title = data['title'] ?? 'Sem título';
          final description = data['description'] is String
              ? data['description']
              : (data['description']?['value'] ?? 'Sem descrição');
          final covers = data['covers'] ?? [];
          final coverId = covers.isNotEmpty ? covers[0] : null;

          final imageUrl = coverId != null
              ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
              : 'https://via.placeholder.com/200x300?text=Sem+Capa';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
