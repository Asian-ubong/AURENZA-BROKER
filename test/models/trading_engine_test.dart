import 'package:flutter_test/flutter_test.dart';
import 'package:aurenza_broker/models/trading_engine.dart';

void main() {
  group('TradingEngine Tests', () {
    late TradingEngine engine;

    setUp(() {
      engine = TradingEngine();
    });

    test('Initial balance should be 1000', () {
      expect(engine.getTotalBalance(), 1000.0);
    });

    test('Create trade should add to trades list', () {
      engine.createTrade('EUR/USD', 1.2000, 10, 'BUY');
      expect(engine.getTrades().length, 1);
    });

    test('Close trade with profit should increase balance', () {
      engine.createTrade('EUR/USD', 1.2000, 10, 'BUY');
      final tradeId = engine.getTrades().first.id;
      engine.closeTrade(tradeId, 1.2100);
      expect(engine.getTotalBalance(), greaterThan(1000.0));
    });

    test('Get open trades should return only open trades', () {
      engine.createTrade('EUR/USD', 1.2000, 10, 'BUY');
      engine.createTrade('GBP/USD', 1.3000, 5, 'SELL');
      expect(engine.getOpenTrades().length, 2);
    });
  });
}
