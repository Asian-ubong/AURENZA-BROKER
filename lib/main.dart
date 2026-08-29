import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'core/theme/orenza_theme.dart';
import 'core/widgets/system_states.dart';
import 'features/dashboard/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SupabaseConfig.logStatus();

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  }

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

class BrokerDestination {
  final String title;
  final IconData icon;

  const BrokerDestination(this.title, this.icon);
}

const destinations = [
  BrokerDestination('Dashboard', Icons.dashboard_outlined),
  BrokerDestination(
    'Wallet',
    Icons.account_balance_wallet_outlined,
  ),
  BrokerDestination('Markets', Icons.show_chart_outlined),
  BrokerDestination('Trading', Icons.swap_vert_rounded),
  BrokerDestination(
    'Trade History',
    Icons.receipt_long_outlined,
  ),
  BrokerDestination(
    'Trending AI',
    Icons.auto_awesome_outlined,
  ),
  BrokerDestination('Security', Icons.security_outlined),
  BrokerDestination(
    'Connected Brokers',
    Icons.link_outlined,
  ),
  BrokerDestination(
    'Support',
    Icons.support_agent_outlined,
  ),
  BrokerDestination('Settings', Icons.settings_outlined),
];

class BrokerShell extends StatefulWidget {
  const BrokerShell({super.key});

  @override
  State<BrokerShell> createState() => _BrokerShellState();
}

class _BrokerShellState extends State<BrokerShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return Row(
              children: [
                _DesktopSidebar(
                  selectedIndex: selectedIndex,
                  onSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                ),
                Expanded(
                  child: _Content(
                    index: selectedIndex,
                  ),
                ),
              ],
            );
          }

          return _MobileShell(
            selectedIndex: selectedIndex,
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

  const _DesktopSidebar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: OrenzaColors.forest,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 25, 22, 30),
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
                          fontWeight: FontWeight.w800,
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
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final selected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: selected
                          ? Colors.white.withValues(alpha: .11)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          destinations[index].icon,
                          color: selected
                              ? OrenzaColors.gold
                              : Colors.white60,
                          size: 20,
                        ),
                        title: Text(
                          destinations[index].title,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.white70,
                            fontSize: 12.5,
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w500,
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
                  Text(
                    'SECURE MODE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
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

class _MobileShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _MobileShell({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const mobileIndexes = [0, 1, 2, 3];

    final currentIsPrimary =
        mobileIndexes.contains(selectedIndex);

    final navIndex = currentIsPrimary
        ? mobileIndexes.indexOf(selectedIndex)
        : 4;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.diamond_outlined,
              color: OrenzaColors.gold,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              destinations[selectedIndex].title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: BackendStatusBadge(
              configured: SupabaseConfig.isConfigured,
              online: false,
            ),
          ),
        ],
      ),
      body: _Content(index: selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navIndex,
        onDestinationSelected: (value) {
          if (value == 4) {
            _showMore(context);
          } else {
            onSelected(mobileIndexes[value]);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
            ),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_vert_rounded),
            label: 'Trade',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var i = 4; i < destinations.length; i++)
                ListTile(
                  leading: Icon(destinations[i].icon),
                  title: Text(destinations[i].title),
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(i);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  final int index;

  const _Content({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return const DashboardScreen();
    }

    final destination = destinations[index];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AurenzaEmptyState(
          icon: destination.icon,
          title: '${destination.title} module',
          message:
              'The design shell is ready. This module will receive '
              'its data from the AURENZA backend in the next phase.',
        ),
      ),
    );
  }
}
