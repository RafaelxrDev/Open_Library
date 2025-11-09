class Book {
  final String key; 
  final String title;
  final List<String> authors;
  final int? coverId;
  final String? firstPublishYear;

  Book({
    required this.key,
    required this.title,
    required this.authors,
    this.coverId,
    this.firstPublishYear,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorsList = <String>[];
    if (json['author_name'] != null && json['author_name'] is List) {
      for (var a in json['author_name']) {
        if (a != null) authorsList.add(a.toString());
      }
    }

    return Book(
      key: json['key']?.toString() ?? '',
      title: (json['title'] ?? 'Sem título').toString(),
      authors: authorsList,
      coverId: json['cover_i'] != null ? (json['cover_i'] as num).toInt() : null,
      firstPublishYear: json['first_publish_year']?.toString(),
    );
  }

  String? get coverUrl =>
      coverId != null ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg' : null;

  String get authorsText =>
      authors.isNotEmpty ? authors.join(', ') : 'Autor desconhecido';
}
