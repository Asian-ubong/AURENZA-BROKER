import 'package:flutter_test/flutter_test.dart';
import 'package:aurenza_broker/main.dart';

void main() {
  testWidgets('AURENZA backend-unavailable screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const AurenzaApp(
        backendReady: false,
      ),
    );

    expect(
      find.textContaining('AURENZA could not connect to its backend'),
      findsOneWidget,
    );

    expect(
      find.textContaining('Configure Supabase and restart the application'),
      findsOneWidget,
    );
  });
}
