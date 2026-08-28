import 'package:flutter/material.dart';

void main() {
  runApp(const AurenzaApp());
}

class AurenzaApp extends StatelessWidget {
  const AurenzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AURENZA Broker',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F80ED),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const BrokerDashboard(),
    );
  }
}

class BrokerDashboard extends StatefulWidget {
  const BrokerDashboard({super.key});

  @override
  State<BrokerDashboard> createState() => _BrokerDashboardState();
}

class _BrokerDashboardState extends State<BrokerDashboard> {
  int _currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double sandboxBalance = 0;
  double dailyAllocated = 0;

  static const double treasury = 1000000;
  static const double minimumAllocation = 50;
  static const double maximumAllocation = 200;
  static const double dailyLimit = 200;

  final TextEditingController allocationController = TextEditingController();
  final List<SandboxTransaction> transactions = [];

  double get remainingDailyAllocation =>
      (dailyLimit - dailyAllocated).clamp(0, dailyLimit);

  void _navigateToPage(int index) {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    }
    setState(() {
      _currentPageIndex = index;
    });
  }

  void requestAllocation() {
    final amount = double.tryParse(allocationController.text.trim());

    if (amount == null) {
      _showMessage('Enter a valid allocation amount.');
      return;
    }

    if (amount < minimumAllocation) {
      _showMessage('Minimum sandbox allocation is \$50.');
      return;
    }

    if (amount > maximumAllocation) {
      _showMessage('Maximum allocation per request is \$200.');
      return;
    }

    if (dailyAllocated + amount > dailyLimit) {
      _showMessage(
        'Daily allocation limit exceeded. '
        'You have \$${remainingDailyAllocation.toStringAsFixed(2)} remaining.',
      );
      return;
    }

    setState(() {
      sandboxBalance += amount;
      dailyAllocated += amount;

      transactions.insert(
        0,
        SandboxTransaction(
          id: 'SBX-${DateTime.now().millisecondsSinceEpoch}',
          amount: amount,
          type: 'SANDBOX_ALLOCATION',
          timestamp: DateTime.now(),
        ),
      );
    });

    allocationController.clear();

    _showMessage(
      '\$${amount.toStringAsFixed(2)} sandbox capital allocated.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    allocationController.dispose();
    super.dispose();
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
            title: const Text(
              'AURENZA BROKER',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF0A1728),
            elevation: 0,
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
        return _buildDashboardPage();
      case 1:
        return _buildWalletPage();
      case 2:
        return _buildMarketsPage();
      case 3:
        return _buildTradingPage();
      case 4:
        return _buildTradeHistoryPage();
      case 5:
        return _buildTrendingAIPage();
      case 6:
        return _buildSupportPage();
      case 7:
        return _buildSettingsPage();
      default:
        return _buildDashboardPage();
    }
  }

  Widget _buildDashboardPage() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildTopBar(),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSandboxBanner(),
              const SizedBox(height: 24),
              _buildOverviewCards(),
              const SizedBox(height: 24),
              _buildAllocationSection(),
              const SizedBox(height: 24),
              _buildBrokerConnections(),
              const SizedBox(height: 24),
              _buildTransactions(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Full wallet management coming soon...',
                      style: TextStyle(
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

  Widget _buildMarketsPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Markets',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Live market data and charts coming soon...',
                      style: TextStyle(
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

  Widget _buildTradingPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trading',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Trading interface and order management coming soon...',
                      style: TextStyle(
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

  Widget _buildTradeHistoryPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trade History',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your trading history and analytics coming soon...',
                      style: TextStyle(
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

  Widget _buildTrendingAIPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending AI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'AI-powered market insights and recommendations coming soon...',
                      style: TextStyle(
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

  Widget _buildSupportPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Contact support and help documentation coming soon...\n\nEmail: supportdeveloperer@gmail.com',
                      style: TextStyle(
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

  Widget _buildSettingsPage() {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'User preferences and account settings coming soon...',
                      style: TextStyle(
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

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1728),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(.06),
          ),
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
          _statusChip(),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF183250),
            child: Icon(
              Icons.person_outline,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF123A31),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF1C765E),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Color(0xFF42D392),
          ),
          SizedBox(width: 7),
          Text(
            'SANDBOX MODE',
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

  Widget _buildSandboxBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF102B4A),
            Color(0xFF0B2037),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF245B91),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: Color(0xFF5CA8FF),
            size: 28,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AURENZA SANDBOX / TEST MODE',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: .5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'All balances shown here are virtual test capital. '
                  'No real money can be deposited, withdrawn, transferred, '
                  'or paid out in this version.',
                  style: TextStyle(
                    color: Color(0xFFB7C7DA),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 700;

        final cards = [
          _metricCard(
            title: 'Sandbox Treasury',
            value: '\$1,000,000',
            subtitle: 'Virtual test capital',
            icon: Icons.account_balance_outlined,
          ),
          _metricCard(
            title: 'Your Sandbox Balance',
            value: '\$${sandboxBalance.toStringAsFixed(2)}',
            subtitle: 'Available test capital',
            icon: Icons.account_balance_wallet_outlined,
          ),
          _metricCard(
            title: 'Daily Allocation',
            value: '\$${dailyAllocated.toStringAsFixed(2)}',
            subtitle:
                '\$${remainingDailyAllocation.toStringAsFixed(2)} remaining',
            icon: Icons.speed_outlined,
          ),
          _metricCard(
            title: 'Real Withdrawable',
            value: '\$0.00',
            subtitle: 'Disabled in sandbox',
            icon: Icons.lock_outline,
          ),
        ];

        if (narrow) {
          return Column(
            children: [
              for (final card in cards) ...[card, const SizedBox(height: 12)],
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.4,
          children: cards,
        );
      },
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF112B48),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF62AEFF),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF8FA5BD),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6F879F),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Request Sandbox Capital',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Allocation limits are enforced by the backend in the production architecture.',
            style: TextStyle(
              color: Color(0xFF8299B2),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ruleChip('Minimum \$50'),
              _ruleChip('Maximum \$200'),
              _ruleChip('\$200 Daily Limit'),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: allocationController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Allocation amount',
                    hintText: '50 - 200',
                    prefixText: '\$ ',
                    filled: true,
                    fillColor: const Color(0xFF07111F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: requestAllocation,
                  child: const Text(
                    'Request Allocation',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ruleChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF10263F),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF9CC9F9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBrokerConnections() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxWidth < 650;

        final cards = [
          _brokerCard(
            name: 'Deriv',
            subtitle: 'Demo / Test Connection',
            icon: Icons.show_chart_rounded,
          ),
          _brokerCard(
            name: 'MetaTrader 5',
            subtitle: 'Demo / Test Connection',
            icon: Icons.candlestick_chart_rounded,
          ),
        ];

        if (vertical) {
          return Column(
            children: [
              cards[0],
              const SizedBox(height: 12),
              cards[1],
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 14),
            Expanded(child: cards[1]),
          ],
        );
      },
    );
  }

  Widget _brokerCard({
    required String name,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF10263F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF62AEFF),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7890AA),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lock_outline,
            size: 18,
            color: Color(0xFF637D98),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sandbox Ledger',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Test transactions generated by this session.',
            style: TextStyle(
              color: Color(0xFF7890AA),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No sandbox transactions yet.',
                  style: TextStyle(
                    color: Color(0xFF667E98),
                  ),
                ),
              ),
            )
          else
            ...transactions.map(
              (transaction) => _transactionRow(transaction),
            ),
        ],
      ),
    );
  }

  Widget _transactionRow(SandboxTransaction transaction) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(.05),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.add_circle_outline,
            color: Color(0xFF42D392),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.id,
                  style: const TextStyle(
                    color: Color(0xFF647D98),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+\$${transaction.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF42D392),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class SandboxTransaction {
  final String id;
  final double amount;
  final String type;
  final DateTime timestamp;

  SandboxTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.timestamp,
  });
}

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;

  const Sidebar({required this.onItemSelected, super.key});

  @override
  Widget build(BuildContext context) {
    const menuItems = [
      (Icons.dashboard_outlined, 'Dashboard', 0),
      (Icons.account_balance_wallet_outlined, 'Wallet', 1),
      (Icons.show_chart_outlined, 'Markets', 2),
      (Icons.swap_vert_rounded, 'Trading', 3),
      (Icons.receipt_long_outlined, 'Trade History', 4),
      (Icons.auto_awesome_outlined, 'Trending AI', 5),
      (Icons.support_agent_outlined, 'Support', 6),
      (Icons.settings_outlined, 'Settings', 7),
    ];

    return Container(
      width: 235,
      color: const Color(0xFF081421),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AURENZA',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'BROKER',
                style: TextStyle(
                  color: Color(0xFF5D91C8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 35),
              ...menuItems.map(
                (item) => _buildMenuItem(
                  context,
                  item.$1,
                  item.$2,
                  item.$3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 19,
          color: const Color(0xFF70869D),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8297AC),
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () => onItemSelected(index),
      ),
    );
  }
}
