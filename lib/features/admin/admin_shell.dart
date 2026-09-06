import 'package:flutter/material.dart';

import '../../core/theme/aurenza_colors.dart';
import 'admin_access.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int selectedIndex = 0;

  static const sections = <String>[
    'Overview', 'Users', 'KYC & Compliance', 'Finance', 'Trading Monitor',
    'Investment Profit', 'Withdrawals', 'Risk & Security', 'Brokers', 'AI Center',
    'Support', 'Roles & Permissions', 'Audit Logs', 'System Settings', 'System Health',
  ];

  static const icons = <IconData>[
    Icons.dashboard_outlined, Icons.people_outline, Icons.verified_user_outlined,
    Icons.account_balance_outlined, Icons.monitor_heart_outlined, Icons.auto_graph_outlined,
    Icons.payments_outlined, Icons.security_outlined, Icons.link_outlined,
    Icons.auto_awesome_outlined, Icons.support_agent_outlined,
    Icons.admin_panel_settings_outlined, Icons.receipt_long_outlined,
    Icons.settings_outlined, Icons.health_and_safety_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    if (!AurenzaAdminAccess.isAdmin) return const _AdminDeniedScreen();

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return Row(children: [
            _AdminDesktopSidebar(
              selectedIndex: selectedIndex,
              onSelected: (index) => setState(() => selectedIndex = index),
            ),
            Expanded(child: _AdminPage(section: sections[selectedIndex])),
          ]);
        }
        if (constraints.maxWidth >= 700) {
          return Row(children: [
            NavigationRail(
              backgroundColor: AurenzaColors.forest,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => setState(() => selectedIndex = index),
              selectedIconTheme: const IconThemeData(color: AurenzaColors.gold),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              destinations: [
                for (var i = 0; i < icons.length; i++)
                  NavigationRailDestination(icon: Icon(icons[i]), selectedIcon: Icon(icons[i]), label: Text(sections[i])),
              ],
            ),
            Expanded(child: _AdminPage(section: sections[selectedIndex])),
          ]);
        }
        return Scaffold(
          appBar: AppBar(title: Text(sections[selectedIndex])),
          body: _AdminPage(section: sections[selectedIndex]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex.clamp(0, 3).toInt(),
            onDestinationSelected: (index) => setState(() => selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
              NavigationDestination(icon: Icon(Icons.people_outline), label: 'Users'),
              NavigationDestination(icon: Icon(Icons.security_outlined), label: 'Risk'),
              NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
            ],
          ),
        );
      }),
    );
  }
}

class _AdminDesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _AdminDesktopSidebar({required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) => Container(
        width: 280,
        color: AurenzaColors.forest,
        child: SafeArea(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 24, 22, 18),
              child: Row(children: [
                Icon(Icons.admin_panel_settings_outlined, color: AurenzaColors.gold, size: 30),
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AURENZA', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  Text('ADMIN CONTROL', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
                ]),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _AdminShellState.sections.length,
                itemBuilder: (context, index) {
                  final selected = selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: ListTile(
                      dense: true,
                      selected: selected,
                      selectedTileColor: Colors.white.withValues(alpha: .12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      leading: Icon(_AdminShellState.icons[index], color: selected ? AurenzaColors.gold : Colors.white70),
                      title: Text(_AdminShellState.sections[index], style: TextStyle(color: selected ? Colors.white : Colors.white70, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                      onTap: () => onSelected(index),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18),
              child: Row(children: [
                Icon(Icons.lock_outline, color: AurenzaColors.gold, size: 18),
                SizedBox(width: 8),
                Text('AUTHORIZED ADMIN AREA', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
        ),
      );
}

class _AdminPage extends StatelessWidget {
  final String section;

  const _AdminPage({required this.section});

  @override
  Widget build(BuildContext context) {
    final overview = section == 'Overview';
    return Column(children: [
      if (MediaQuery.sizeOf(context).width >= 700)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AurenzaColors.border))),
          child: Row(children: [
            Text(section, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            const Chip(avatar: Icon(Icons.shield_outlined, size: 16), label: Text('Admin')),
          ]),
        ),
      Expanded(child: overview ? const _AdminOverview() : _AdminPlaceholder(section: section)),
    ]);
  }
}

class _AdminOverview extends StatelessWidget {
  const _AdminOverview();

  @override
  Widget build(BuildContext context) {
    const metrics = <(String, String, IconData)>[
      ('Users', '—', Icons.people_outline),
      ('KYC Verified', '—', Icons.verified_user_outlined),
      ('Active Traders', '—', Icons.show_chart_outlined),
      ('Sandbox Treasury', r'$1,000,000', Icons.account_balance_outlined),
      ('Allocated', '—', Icons.pie_chart_outline),
      ('Open Trades', '—', Icons.swap_vert_rounded),
      ('Today P&L', '—', Icons.trending_up),
      ('Broker Status', 'Checking', Icons.link_outlined),
    ];

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text('AURENZA Admin Control Center', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('Module 1 foundation is active. Financial and operational metrics will be connected through authorized backend repositories in later modules.'),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 280, mainAxisExtent: 130, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return Card(child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(metric.$3, color: AurenzaColors.gold),
                const Spacer(),
                Text(metric.$1, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(metric.$2, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ]),
            ));
          },
        ),
        const SizedBox(height: 24),
        const Card(child: ListTile(
          leading: Icon(Icons.info_outline, color: AurenzaColors.gold),
          title: Text('Foundation status'),
          subtitle: Text('Admin shell, responsive navigation, role gate, module registry, and safe placeholder states are ready. No client-side action can mutate money or trading state.'),
        )),
      ],
    );
  }
}

class _AdminPlaceholder extends StatelessWidget {
  final String section;

  const _AdminPlaceholder({required this.section});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.construction_outlined, size: 54, color: AurenzaColors.gold),
            const SizedBox(height: 16),
            Text(section, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Admin module registered. Screen, repository, permissions, backend RPCs, and tests will be implemented in its module phase.'),
          ]),
        ),
      );
}

class _AdminDeniedScreen extends StatelessWidget {
  const _AdminDeniedScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('AURENZA Admin')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.lock_outline, size: 56, color: AurenzaColors.gold),
              SizedBox(height: 18),
              Text('Admin access required', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              SizedBox(height: 10),
              Text('Your authenticated account does not have an authorized AURENZA admin role.'),
            ]),
          ),
        ),
      );
}
