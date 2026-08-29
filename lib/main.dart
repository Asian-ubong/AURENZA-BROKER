import 'package:flutter/material.dart';

import 'core/theme/orenza_theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AurenzaApp());
}

class AurenzaApp extends StatelessWidget {
  const AurenzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURENZA Broker',
      debugShowCheckedModeBanner: false,
      theme: OrenzaTheme.light(),
      home: const BrokerShell(),
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

  final List<String> titles = [
    'Dashboard',
    'Wallet',
    'Sandbox',
    'Markets',
    'Trading',
    'Trade History',
    'Trending AI',
    'Security',
    'Connected Brokers',
    'Support',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 900;

          if (desktop) {
            return Row(
              children: [
                _DesktopSidebar(
                  selectedIndex: selectedIndex,
                  onSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                  titles: titles,
                ),
                Expanded(
                  child: _Content(
                    title: titles[selectedIndex],
                    selectedIndex: selectedIndex,
                  ),
                ),
              ],
            );
          }

          return _MobileLayout(
            selectedIndex: selectedIndex,
            titles: titles,
            onSelected: (index) {
              setState(() => selectedIndex = index);
            },
          );
        },
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<String> titles;

  const _DesktopSidebar({
    required this.selectedIndex,
    required this.onSelected,
    required this.titles,
  });

  static const icons = [
    Icons.dashboard_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.shield_outlined,
    Icons.show_chart_outlined,
    Icons.swap_vert_rounded,
    Icons.receipt_long_outlined,
    Icons.auto_awesome_outlined,
    Icons.security_outlined,
    Icons.link_outlined,
    Icons.support_agent_outlined,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: OrenzaColors.forestGreen,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 24, 22, 30),
              child: Row(
                children: [
                  Icon(
                    Icons.diamond_outlined,
                    color: OrenzaColors.gold,
                    size: 27,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AURENZA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'BROKER',
                        style: TextStyle(
                          color: OrenzaColors.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  final selected = index == selectedIndex;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: selected
                          ? Colors.white.withValues(alpha: .12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          icons[index],
                          color: selected ? OrenzaColors.gold : Colors.white70,
                          size: 20,
                        ),
                        title: Text(
                          titles[index],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        onTap: () => onSelected(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: OrenzaColors.gold,
                    size: 17,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SANDBOX MODE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String title;
  final int selectedIndex;

  const _Content({required this.title, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 0) {
      return Column(
        children: [
          _TopBar(title: title),
          const Expanded(child: DashboardScreen()),
        ],
      );
    }

    return Column(
      children: [
        _TopBar(title: title),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction_outlined,
                  size: 46,
                  color: OrenzaColors.gold,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Module foundation ready for implementation.',
                  style: TextStyle(color: OrenzaColors.slate),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;

  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: OrenzaColors.ivory,
        border: Border(bottom: BorderSide(color: OrenzaColors.border)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: OrenzaColors.successBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: OrenzaColors.emerald),
                SizedBox(width: 7),
                Text(
                  'Sandbox Active',
                  style: TextStyle(
                    color: OrenzaColors.forestGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const CircleAvatar(
            backgroundColor: OrenzaColors.forestGreen,
            child: Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final List<String> titles;
  final ValueChanged<int> onSelected;

  const _MobileLayout({
    required this.selectedIndex,
    required this.titles,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AURENZA',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: OrenzaColors.forestGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'SANDBOX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: selectedIndex == 0
          ? const DashboardScreen()
          : Center(
              child: Text(
                titles[selectedIndex],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex > 4 ? 0 : selectedIndex,
        onDestinationSelected: onSelected,
        indicatorColor: OrenzaColors.gold.withValues(alpha: .25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
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
          NavigationDestination(icon: Icon(Icons.swap_vert), label: 'Trade'),
          NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}
