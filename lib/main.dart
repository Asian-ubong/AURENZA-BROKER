import 'package:flutter/material.dart';

import 'core/backend/supabase_client.dart';
import 'core/brand/aurenza_wordmark.dart';
import 'core/theme/aurenza_colors.dart';
import 'core/theme/aurenza_theme.dart';
import 'core/widgets/app_error.dart';
import 'features/admin/admin_access.dart';
import 'features/admin/admin_shell.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/investment_profit/investment_profit_screen.dart';
import 'features/wallet/wallet_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var ready = false;
  try {
    ready = await AurenzaSupabase.initialize();
  } catch (error) {
    debugPrint('ORANZO ADMIN: Supabase initialization failed: $error');
  }
  runApp(AurenzaApp(backendReady: ready));
}

class AurenzaApp extends StatelessWidget {
  final bool backendReady;

  const AurenzaApp({super.key, required this.backendReady});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORANZO ADMIN',
      debugShowCheckedModeBanner: false,
      theme: AurenzaTheme.light(),
      home: backendReady
          ? const BrokerShell()
          : const BackendUnavailableScreen(),
    );
  }
}

class BackendUnavailableScreen extends StatelessWidget {
  const BackendUnavailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AppError(
            message:
                'ORANZO ADMIN could not connect to its backend.\n\nConfigure Supabase and restart the application.',
            onRetry: main,
          ),
        ),
      ),
    );
  }
}

class BrokerShell extends StatefulWidget {
  const BrokerShell({super.key});

  @override
  State<BrokerShell> createState() => _BrokerShellState();
}

class _BrokerShellState extends State<BrokerShell> {
  int selectedIndex = 0;

  final titles = const [
    'Dashboard',
    'Wallet',
    'Sandbox',
    'Markets',
    'Trading',
    'Investment Profit',
    'Trade History',
    'Trending AI',
    'Security',
    'Connected Brokers',
    'Support',
    'Settings',
  ];

  final icons = const [
    Icons.dashboard_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.shield_outlined,
    Icons.show_chart_outlined,
    Icons.swap_vert_rounded,
    Icons.calculate_outlined,
    Icons.receipt_long_outlined,
    Icons.auto_awesome_outlined,
    Icons.security_outlined,
    Icons.link_outlined,
    Icons.support_agent_outlined,
    Icons.settings_outlined,
  ];

  void openAdmin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AdminShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1100) {
            return Row(
              children: [
                _Side(
                  titles,
                  icons,
                  selectedIndex,
                  (index) => setState(() => selectedIndex = index),
                  AurenzaAdminAccess.isAdmin ? openAdmin : null,
                ),
                Expanded(
                  child: _Page(titles[selectedIndex], selectedIndex),
                ),
              ],
            );
          }

          if (constraints.maxWidth >= 700) {
            return Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => selectedIndex = index),
                  backgroundColor: AurenzaColors.forest,
                  selectedIconTheme:
                      const IconThemeData(color: AurenzaColors.gold),
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.white70),
                  destinations: [
                    for (var i = 0; i < icons.length; i++)
                      NavigationRailDestination(
                        icon: Icon(icons[i]),
                        selectedIcon: Icon(icons[i]),
                        label: const SizedBox.shrink(),
                      ),
                  ],
                ),
                Expanded(
                  child: _Page(titles[selectedIndex], selectedIndex),
                ),
              ],
            );
          }

          final bottomIndex = selectedIndex > 3 ? 0 : selectedIndex;
          return Scaffold(
            appBar: AppBar(
              title: const AurenzaWordmark(compact: true),
              actions: [
                if (AurenzaAdminAccess.isAdmin)
                  IconButton(
                    onPressed: openAdmin,
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                  ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),
            body: _Page(titles[selectedIndex], selectedIndex),
            bottomNavigationBar: NavigationBar(
              selectedIndex: bottomIndex,
              onDestinationSelected: (index) =>
                  setState(() => selectedIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: 'Wallet',
                ),
                NavigationDestination(
                  icon: Icon(Icons.show_chart_outlined),
                  label: 'Markets',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu),
                  label: 'More',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Side extends StatelessWidget {
  final List<String> titles;
  final List<IconData> icons;
  final int selected;
  final ValueChanged<int> onSelected;
  final VoidCallback? admin;

  const _Side(
    this.titles,
    this.icons,
    this.selected,
    this.onSelected,
    this.admin,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AurenzaColors.forest,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(
                    Icons.diamond_outlined,
                    color: AurenzaColors.gold,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'ORANZO ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    selected: index == selected,
                    selectedTileColor: Colors.white.withValues(alpha: .12),
                    leading: Icon(
                      icons[index],
                      color: index == selected
                          ? AurenzaColors.gold
                          : Colors.white70,
                    ),
                    title: Text(
                      titles[index],
                      style: TextStyle(
                        color: index == selected
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                    onTap: () => onSelected(index),
                  );
                },
              ),
            ),
            if (admin != null)
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AurenzaColors.gold,
                ),
                title: const Text(
                  'Admin Console',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Authorized',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                onTap: admin,
              ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'SANDBOX MODE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String title;
  final int index;

  const _Page(this.title, this.index);

  @override
  Widget build(BuildContext context) {
    late final Widget body;
    switch (index) {
      case 0:
        body = const DashboardScreen();
      case 1:
        body = const WalletScreen();
      case 5:
        body = const InvestmentProfitScreen();
      default:
        body = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction_outlined,
                size: 48,
                color: AurenzaColors.gold,
              ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('Module foundation ready for backend implementation.'),
            ],
          ),
        );
    }

    return Column(
      children: [
        if (MediaQuery.sizeOf(context).width >= 700)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AurenzaColors.border),
              ),
            ),
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                const Icon(Icons.notifications_none),
                const SizedBox(width: 18),
                const CircleAvatar(
                  backgroundColor: AurenzaColors.forest,
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
              ],
            ),
          ),
        Expanded(child: body),
      ],
    );
  }
}
