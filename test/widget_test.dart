import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbear/main.dart';

void main() {
  testWidgets('home shows food discovery and category filters', (tester) async {
    await tester.pumpWidget(const FoodBearApp());

    expect(find.bySemanticsLabel('FoodBear bear logo'), findsOneWidget);
    expect(find.text('Manila, Philippines'), findsOneWidget);
    expect(find.text('Hungry?'), findsOneWidget);
    expect(find.text('Classic Smash'), findsOneWidget);

    await tester.tap(find.text('Pizza'));
    await tester.pump();

    expect(find.text('Garden Margherita'), findsOneWidget);
    expect(find.text('Classic Smash'), findsNothing);
  });

  testWidgets('items can be added to the bag and quantities updated',
      (tester) async {
    await tester.pumpWidget(const FoodBearApp());

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-classic-burger')));
    await tester.pump();
    await tester.tap(find.text('Bag'));
    await tester.pump();

    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('₱289.00'), findsWidgets);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();

    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('₱578.00'), findsWidgets);
  });

  testWidgets('favorites can be saved and viewed', (tester) async {
    await tester.pumpWidget(const FoodBearApp());

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('favorite-classic-burger')));
    await tester.pump();
    await tester.tap(find.text('Favorites'));
    await tester.pump();

    expect(find.text('Your favorites'), findsOneWidget);
    expect(find.text('Classic Smash'), findsOneWidget);
  });
}
