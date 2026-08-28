class TradingEngine {
  static final TradingEngine _instance = TradingEngine._internal();
  
  factory TradingEngine() {
    return _instance;
  }
  
  TradingEngine._internal();

  double _balance = 1000.0;
  final List<Trade> _trades = [];

  // Create a trade
  void createTrade(String symbol, double entryPrice, double quantity, String type) {
    final trade = Trade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      entryPrice: entryPrice,
      quantity: quantity,
      type: type,
      status: 'OPEN',
      timestamp: DateTime.now(),
      pnl: 0,
      isWin: false,
    );
    _trades.add(trade);
  }

  // Close a trade
  void closeTrade(String tradeId, double exitPrice) {
    final tradeIndex = _trades.indexWhere((t) => t.id == tradeId);
    if (tradeIndex != -1) {
      final trade = _trades[tradeIndex];
      final pnl = (exitPrice - trade.entryPrice) * trade.quantity;
      _balance += pnl;
      _trades[tradeIndex] = Trade(
        id: trade.id,
        symbol: trade.symbol,
        entryPrice: trade.entryPrice,
        quantity: trade.quantity,
        type: trade.type,
        status: 'CLOSED',
        timestamp: trade.timestamp,
        pnl: pnl,
        isWin: pnl >= 0,
      );
    }
  }

  // Get total balance
  double getTotalBalance() {
    return _balance;
  }

  // Get all trades
  List<Trade> getTrades() {
    return List.unmodifiable(_trades);
  }

  // Get open trades
  List<Trade> getOpenTrades() {
    return _trades.where((t) => t.status == 'OPEN').toList();
  }

  // Get daily P&L
  double getDailyPnL() {
    final today = DateTime.now();
    return _trades
        .where((t) => t.timestamp.day == today.day && t.timestamp.month == today.month && t.timestamp.year == today.year)
        .fold(0.0, (sum, t) => sum + t.pnl);
  }

  // Get win rate
  double getWinRate() {
    if (_trades.isEmpty) return 0;
    final wins = _trades.where((t) => t.isWin).length;
    return (wins / _trades.length) * 100;
  }

  // Get average return
  double getAverageReturn() {
    if (_trades.isEmpty) return 0;
    final totalPnL = _trades.fold(0.0, (sum, t) => sum + t.pnl);
    return totalPnL / _trades.length;
  }
}

class Trade {
  final String id;
  final String symbol;
  final double entryPrice;
  final double quantity;
  final String type; // BUY or SELL
  final String status; // OPEN or CLOSED
  final DateTime timestamp;
  final double pnl;
  final bool isWin;

  Trade({
    required this.id,
    required this.symbol,
    required this.entryPrice,
    required this.quantity,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.pnl,
    required this.isWin,
  });
}
