import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    final provider = Provider.of<BookProvider>(context, listen: false);
    provider.search(_searchController.text);
  }

  void _onClear() {
    _searchController.clear();
    final provider = Provider.of<BookProvider>(context, listen: false);
    provider.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca - OpenLibrary'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _onSearch(),
                      decoration: InputDecoration(
                        hintText: 'Digite título, autor ou termo...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _onClear,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),
            ),

            // Estado: loading / error / empty / list
            if (provider.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator())) 
            else if (provider.error != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Erro: ${provider.error}', textAlign: TextAlign.center),
                  ),
                ),
              )
            else if (provider.books.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      _searchController.text.trim().isEmpty
                          ? 'Digite um termo e pressione buscar.'
                          : 'Nenhum resultado encontrado para "${_searchController.text}".',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // re-executa a busca atual
                    await Provider.of<BookProvider>(context, listen: false)
                        .search(_searchController.text);
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.books.length,
                    itemBuilder: (context, index) {
                      final item = provider.books[index];
                      return BookItem(book: item);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
