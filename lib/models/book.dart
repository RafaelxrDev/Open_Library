class Book {
  final String title;
  final List<String> authors;
  final int? coverId;

  Book({
    required this.title,
    required this.authors,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorsList = <String>[];
    if (json['author_name'] != null && json['author_name'] is List) {
      for (var a in json['author_name']) {
        if (a != null) authorsList.add(a.toString());
      }
    }
    return Book(
      title: (json['title'] ?? 'Untitled').toString(),
      authors: authorsList,
      coverId: json['cover_i'] != null ? (json['cover_i'] as num).toInt() : null,
    );
  }
}
