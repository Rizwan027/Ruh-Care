import 'package:flutter_test/flutter_test.dart';

import 'package:ruh_care/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Verify splash screen renders
    expect(find.text('Ruh-Care'), findsOneWidget);
  });
}
