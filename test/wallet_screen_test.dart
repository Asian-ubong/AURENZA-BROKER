import 'package:flutter_test/flutter_test.dart';
import 'package:oranzo_admin/features/wallet/wallet_screen.dart';

void main() {
  test('wallet snapshot parses backend values', () {
    const w = WalletSnapshot({
      'currency': 'USD',
      'total_balance': 230,
      'available_balance': 150,
      'reserved_balance': 50,
      'sandbox_capital': 200,
      'trading_balance': 50,
      'profit': 30,
      'withdrawable_balance': 30,
      'sandbox_mode': true,
    });
    expect(w.n('total_balance'), 230);
    expect(w.n('available_balance'), 150);
    expect(w.n('profit'), 30);
    expect(w.sandbox, isTrue);
  });
}
