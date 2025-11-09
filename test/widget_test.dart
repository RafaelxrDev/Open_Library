import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:openlibrary_app/main.dart';
import 'package:openlibrary_app/providers/book_provider.dart';

void main() {
  testWidgets('App inicia e exibe título principal', (WidgetTester tester) async {
    // Envolve o app com o Provider necessário
    await tester.pumpWidget(
      ChangeNotifierProvider<BookProvider>(
        create: (_) => BookProvider(),
        child: const MyApp(),
      ),
    );

    // Aguarda a renderização
    await tester.pumpAndSettle();

    // Verifica se o título principal aparece na AppBar
    expect(find.text('OpenLibrary Finder'), findsOneWidget);

    // Verifica se o campo de pesquisa está presente
    expect(find.byType(TextField), findsOneWidget);
  });
}
