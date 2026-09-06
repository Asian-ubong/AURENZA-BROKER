import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:oranzo_admin/features/admin/admin_finance_screen.dart';

void main() {
  testWidgets(
    'finance screen does not fabricate wallet data when backend is unavailable',
    (tester) async {
      if (!Supabase.instance.isInitialized) {
        await Supabase.initialize(
          url: 'https://example.supabase.co',
          anonKey: 'test-anon-key',
        );
      }

      await tester.pumpWidget(
        const MaterialApp(home: AdminFinanceScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Company & User Wallets'), findsOneWidget);
      expect(
        find.textContaining('Backend wallet data is not available yet'),
        findsOneWidget,
      );
    },
  );
}
