import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';

void main() {
  testWidgets('Campus Event Explorer opens correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusEventApp());

    expect(find.text('Explore Events'), findsOneWidget);
    expect(find.text('6 events found'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
