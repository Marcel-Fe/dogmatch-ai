import 'package:dogmatch_ai/core/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptyView zeigt Titel und Nachricht an', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyView(title: 'Keine Daten', message: 'Noch nichts hier.'),
        ),
      ),
    );

    expect(find.text('Keine Daten'), findsOneWidget);
    expect(find.text('Noch nichts hier.'), findsOneWidget);
  });
}
