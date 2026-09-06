import 'package:flutter_test/flutter_test.dart';
import 'package:oranzo_admin/main.dart';

void main() {
  testWidgets('ORANZO ADMIN shell renders when backend is unavailable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const OranzoAdminApp(
        backendReady: false,
      ),
    );

    expect(find.text('ORANZO ADMIN'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
  });
}
