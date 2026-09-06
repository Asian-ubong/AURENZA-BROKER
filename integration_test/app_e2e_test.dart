import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:oranzo_admin/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> launchApp(WidgetTester tester) async {
    await app.main();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  testWidgets('ORANZO ADMIN cold launch E2E smoke test', (tester) async {
    await launchApp(tester);

    expect(find.text('ORANZO ADMIN'), findsWidgets);

    final unavailable = find.textContaining('could not connect to its backend');
    if (unavailable.evaluate().isNotEmpty) {
      expect(unavailable, findsOneWidget);
      return;
    }

    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('ORANZO ADMIN survives phone relayout', (tester) async {
    await launchApp(tester);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(1280, 800));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
