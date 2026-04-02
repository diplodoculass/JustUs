import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_us/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: JustUsApp()),
    );
    await tester.pump();

    // Verify splash screen renders with app name
    expect(find.text('JustUs'), findsOneWidget);
  });
}
