import 'package:flutter_test/flutter_test.dart';

import 'package:aurenza_broker/main.dart';

void main() {
  testWidgets('AURENZA app renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const AurenzaApp(
        backendReady: false,
      ),
    );

    expect(find.text('AURENZA'), findsWidgets);
    expect(find.text('BROKER'), findsWidgets);
  });
}
