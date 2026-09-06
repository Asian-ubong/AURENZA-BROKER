import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurenza_broker/features/admin/admin_finance_screen.dart';

void main() {
  testWidgets('finance screen exposes separate company and user wallet areas', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AdminFinanceScreen()),
    );

    await tester.pump();
    expect(find.text('Company & User Wallets'), findsOneWidget);
    expect(find.text('COMPANY WALLET'), findsOneWidget);
    expect(find.text('User Wallets'), findsNothing);
  });
}
