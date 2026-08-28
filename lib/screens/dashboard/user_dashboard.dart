import 'package:flutter/material.dart';
import 'package:aurenza_broker/models/trading_engine.dart';
import 'package:aurenza_broker/widgets/sidebar.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late TradingEngine _tradingEngine;
  int _currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tradingEngine = TradingEngine();
  }

  void _navigateToPage(int index) {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    }
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;

        if (isDesktop) {
          return Scaffold(
            key: _scaffoldKey,
            body: SafeArea(
              child: Row(
                children: [
                  Sidebar(onItemSelected: _navigateToPage),
                  Expanded(
                    child: _buildPageContent(),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('AURENZA BROKER'),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: Sidebar(onItemSelected: _navigateToPage),
          ),
          body: _buildPageContent(),
        );
      },
    );
  }

  Widget _buildPageContent() {
    switch (_currentPageIndex) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return _buildWalletPage();
      case 2:
        return _buildMarketsPage();
      case 3:
        return _buildTradingPage();
      case 4:
        return _buildTradeHistoryPage();
      case 5:
        return _buildChallengesPage();
      case 6:
        return _buildLeaderboardPage();
      case 7:
        return _buildAIAssistantPage();
      case 8:
        return _buildSupportPage();
      case 9:
        return _buildSettingsPage();
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTopBar()),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildPortfolioOverview(),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 24),
              _buildRecentTrades(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1728),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(.06)),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'AURENZA',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'BROKER',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7FA7D8),
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          _buildStatusChip(),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF183250),
            child: Icon(Icons.person_outline, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF123A31),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1C765E)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFF42D392)),
          SizedBox(width: 7),
          Text(
            'TRADING ACTIVE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7DE6BA),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102B4A), Color(0xFF0B2037)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF245B91)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Color(0xFF8FA5BD),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_tradingEngine.getTotalBalance().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF42D392),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily P&L',
                    style: TextStyle(
                      color: Color(0xFF8FA5BD),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_tradingEngine.getDailyPnL() >= 0 ? '+' : ''}\$${_tradingEngine.getDailyPnL().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: _tradingEngine.getDailyPnL() >= 0
                          ? const Color(0xFF42D392)
                          : const Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 700;
        final stats = [
          ('Win Rate', '${_tradingEngine.getWinRate().toStringAsFixed(1)}%', Icons.trending_up_rounded),
          ('Total Trades', '${_tradingEngine.getTrades().length}', Icons.assessment_rounded),
          ('Avg Return', '${_tradingEngine.getAverageReturn().toStringAsFixed(2)}%', Icons.show_chart_rounded),
          ('Open Positions', '${_tradingEngine.getOpenTrades().length}', Icons.open_in_new_rounded),
        ];

        if (narrow) {
          return Column(
            children: [
              for (final stat in stats) ...[_buildStatCard(stat.$1, stat.$2, stat.$3), const SizedBox(height: 12)],
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: stats.map((s) => _buildStatCard(s.$1, s.$2, s.$3)).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF112B48),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF62AEFF), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Color(0xFF8FA5BD), fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTrades() {
    final trades = _tradingEngine.getTrades();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Trades',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          if (trades.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No trades yet',
                  style: TextStyle(color: Color(0xFF667E98)),
                ),
              ),
            )
          else
            ...trades.take(5).map((trade) => _buildTradeRow(trade)),
        ],
      ),
    );
  }

  Widget _buildTradeRow(Trade trade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: trade.isWin ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              trade.isWin ? Icons.arrow_upward : Icons.arrow_downward,
              color: trade.isWin ? const Color(0xFF42D392) : const Color(0xFFFF6B6B),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trade.symbol,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  trade.timestamp.toString().split('.').first,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF8FA5BD)),
                ),
              ],
            ),
          ),
          Text(
            '${trade.isWin ? '+' : ''}\$${trade.pnl.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: trade.isWin ? const Color(0xFF42D392) : const Color(0xFFFF6B6B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletPage() => _buildPlaceholderPage('Wallet', 'Manage your funds and balances');
  Widget _buildMarketsPage() => _buildPlaceholderPage('Markets', 'View live market data');
  Widget _buildTradingPage() => _buildPlaceholderPage('Trading', 'Execute trades in real-time');
  Widget _buildTradeHistoryPage() => _buildPlaceholderPage('Trade History', 'Review all your past trades');
  Widget _buildChallengesPage() => _buildPlaceholderPage('Challenges', 'Participate in trading competitions');
  Widget _buildLeaderboardPage() => _buildPlaceholderPage('Leaderboard', 'View top traders and rankings');
  Widget _buildAIAssistantPage() => _buildPlaceholderPage('AI Assistant', 'Get trading insights from AI');
  Widget _buildSupportPage() => _buildPlaceholderPage('Support', 'Contact support team');
  Widget _buildSettingsPage() => _buildPlaceholderPage('Settings', 'Manage your account settings');

  Widget _buildPlaceholderPage(String title, String subtitle) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTopBar()),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B192B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(.07)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8FA5BD),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
