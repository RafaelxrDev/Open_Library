import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> search(String query) async {
    final term = query.trim();
    if (term.isEmpty) {
      _books = [];
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.searchBooks(term);
      _books = result;
      if (_books.isEmpty) {
        _error = null; 
      }
    } catch (e) {
      _error = e.toString();
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _books = [];
    _error = null;
    notifyListeners();
  }
}
