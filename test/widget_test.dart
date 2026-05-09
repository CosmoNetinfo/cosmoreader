import 'package:flutter_test/flutter_test.dart';
import 'package:cosmonet_reader/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CosmoNetApp());

    // Verify that the app title is present.
    expect(find.text('CosmoNet Reader'), findsOneWidget);
  });
}
