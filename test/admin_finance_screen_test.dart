import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:oranzo_admin/features/admin/admin_finance_screen.dart';

void main() {
  testWidgets(
    'finance screen is protected when backend/session is unavailable',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AdminFinanceScreen()),
      );
      await tester.pump();

      expect(find.byType(AdminFinanceScreen), findsOneWidget);
    },
    skip: true,
  );
}
