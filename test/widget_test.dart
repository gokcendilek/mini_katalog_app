import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog_app/app.dart';

void main() {
  testWidgets('Mini Katalog app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniKatalogApp());
    await tester.pumpAndSettle();

    expect(find.text('GokcenDilek'), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });
}
