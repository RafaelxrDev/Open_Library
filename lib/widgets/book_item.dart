import 'package:flutter/material.dart';
import '../models/book.dart';

class BookItem extends StatelessWidget {
  final Book book;
  const BookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = book.coverId != null
        ? 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg'
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 70,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: coverUrl != null
              ? Image.network(
                  coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Icon(Icons.book, size: 36);
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                )
              : const Icon(Icons.book, size: 36),
        ),
        title: Text(book.title),
        subtitle: Text(
          book.authors.isNotEmpty ? book.authors.join(', ') : 'Autor desconhecido',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
