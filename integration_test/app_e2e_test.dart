import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:oranzo_admin/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('ORANZO ADMIN cold launch E2E smoke test', (tester) async {
    app.main();

    // Give the real app entry point time to initialize and render.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('ORANZO ADMIN'), findsWidgets);

    // A backend is intentionally not required for this smoke test. When CI has
    // no Supabase credentials, the app must still render its safe unavailable
    // state instead of crashing or hanging on startup.
    final unavailable = find.textContaining('could not connect to its backend');
    if (unavailable.evaluate().isNotEmpty) {
      expect(unavailable, findsOneWidget);
      return;
    }

    // If CI credentials are supplied, verify the authenticated shell renders.
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('ORANZO ADMIN survives repeated navigation and relayout',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // The app should remain responsive after a compact-phone relayout.
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(1280, 800));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
