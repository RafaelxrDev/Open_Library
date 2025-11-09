import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import 'book_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch(BookProvider provider) {
    FocusScope.of(context).unfocus();
    provider.search(_searchController.text);
  }

  void _onClear(BookProvider provider) {
    _searchController.clear();
    provider.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);
    final isLoading = provider.isLoading;
    final error = provider.error;
    final books = provider.books;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenLibrary Finder'),
        centerTitle: true,
        elevation: 3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _onSearch(provider),
                      decoration: InputDecoration(
                        hintText: 'Pesquisar por título, autor ou termo...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _onClear(provider),
                              )
                            : null,
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _onSearch(provider),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),
            ),

            
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: () {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Erro: $error',
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    );
                  }

                  if (books.isEmpty) {
                    final query = _searchController.text.trim();
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          query.isEmpty
                              ? 'Digite um termo e pressione buscar.'
                              : 'Nenhum resultado encontrado para "$query".',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
  onRefresh: () async {
    await provider.search(_searchController.text);
  },
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.only(top: 6, bottom: 12),
    itemCount: books.length,
    itemBuilder: (context, index) {
      final book = books[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailsPage(workKey: book.key),
            ),
          );
        },
        child: BookCard(book: book),
      );
    },
  ),
);

                }(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
