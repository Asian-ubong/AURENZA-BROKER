import 'package:flutter_test/flutter_test.dart';
import 'package:oranzo_admin/main.dart';

void main() {
  testWidgets('ORANZO ADMIN backend-unavailable screen renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const OranzoAdminApp(
        backendReady: false,
      ),
    );

    expect(
      find.textContaining('ORANZO ADMIN could not connect to its backend'),
      findsOneWidget,
    );

    expect(
      find.textContaining('Configure Supabase and restart the application'),
      findsOneWidget,
    );
  });
}
