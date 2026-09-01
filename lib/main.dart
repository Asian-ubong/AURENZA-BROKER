import 'package:flutter/material.dart';

import 'core/backend/supabase_client.dart';
import 'core/brand/aurenza_wordmark.dart';
import 'core/theme/aurenza_colors.dart';
import 'core/theme/aurenza_theme.dart';
import 'core/widgets/app_error.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/investment_profit/investment_profit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool backendReady = false;
  try { backendReady = await AurenzaSupabase.initialize(); } catch (error) { debugPrint('Supabase initialization failed: $error'); }
  runApp(AurenzaApp(backendReady: backendReady));
}

class AurenzaApp extends StatelessWidget {
  final bool backendReady;
  const AurenzaApp({super.key, required this.backendReady});
  @override
  Widget build(BuildContext context) => MaterialApp(title: 'AURENZA Broker', debugShowCheckedModeBanner: false, theme: AurenzaTheme.light(), home: backendReady ? const BrokerShell() : const BackendUnavailableScreen());
}

class BackendUnavailableScreen extends StatelessWidget {
  const BackendUnavailableScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: AppError(message: 'AURENZA could not connect to its backend.\n\nConfigure Supabase and restart the application.', onRetry: main))));
}

class BrokerShell extends StatefulWidget {
  const BrokerShell({super.key});
  @override State<BrokerShell> createState() => _BrokerShellState();
}

class _BrokerShellState extends State<BrokerShell> {
  int selectedIndex = 0;
  final titles = const ['Dashboard','Wallet','Sandbox','Markets','Trading','Investment Profit','Trade History','Trending AI','Security','Connected Brokers','Support','Settings'];
  final icons = const [Icons.dashboard_outlined,Icons.account_balance_wallet_outlined,Icons.shield_outlined,Icons.show_chart_outlined,Icons.swap_vert_rounded,Icons.calculate_outlined,Icons.receipt_long_outlined,Icons.auto_awesome_outlined,Icons.security_outlined,Icons.link_outlined,Icons.support_agent_outlined,Icons.settings_outlined];

  @override
  Widget build(BuildContext context) => Scaffold(body: LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth >= 1100) return Row(children: [_DesktopSidebar(titles: titles, icons: icons, selectedIndex: selectedIndex, onSelected: (i) => setState(() => selectedIndex = i)), Expanded(child: _Page(title: titles[selectedIndex], index: selectedIndex))]);
    if (constraints.maxWidth >= 700) return Row(children: [_TabletNavigation(icons: icons, selectedIndex: selectedIndex, onSelected: (i) => setState(() => selectedIndex = i)), Expanded(child: _Page(title: titles[selectedIndex], index: selectedIndex))]);
    return _MobileLayout(titles: titles, icons: icons, selectedIndex: selectedIndex, onSelected: (i) => setState(() => selectedIndex = i));
  }));
}

class _DesktopSidebar extends StatelessWidget {
  final List<String> titles; final List<IconData> icons; final int selectedIndex; final ValueChanged<int> onSelected;
  const _DesktopSidebar({required this.titles, required this.icons, required this.selectedIndex, required this.onSelected});
  @override
  Widget build(BuildContext context) => Container(width: 260, color: AurenzaColors.forest, child: SafeArea(child: Column(children: [
    const Padding(padding: EdgeInsets.all(24), child: Row(children: [Icon(Icons.diamond_outlined, color: AurenzaColors.gold, size: 28), SizedBox(width: 10), Text('AURENZA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.2))])),
    Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: titles.length, itemBuilder: (_, index) { final selected = index == selectedIndex; return Padding(padding: const EdgeInsets.only(bottom: 4), child: ListTile(selected: selected, selectedTileColor: Colors.white.withValues(alpha: .12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), leading: Icon(icons[index], color: selected ? AurenzaColors.gold : Colors.white70), title: Text(titles[index], style: TextStyle(color: selected ? Colors.white : Colors.white70, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)), onTap: () => onSelected(index))); })),
    const Padding(padding: EdgeInsets.all(20), child: Row(children: [Icon(Icons.shield_outlined, color: AurenzaColors.gold), SizedBox(width: 8), Text('SANDBOX MODE', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 11))]))
  ])));
}

class _TabletNavigation extends StatelessWidget {
  final List<IconData> icons; final int selectedIndex; final ValueChanged<int> onSelected;
  const _TabletNavigation({required this.icons, required this.selectedIndex, required this.onSelected});
  @override
  Widget build(BuildContext context) => NavigationRail(selectedIndex: selectedIndex, onDestinationSelected: onSelected, backgroundColor: AurenzaColors.forest, indicatorColor: AurenzaColors.gold.withValues(alpha: .2), selectedIconTheme: const IconThemeData(color: AurenzaColors.gold), unselectedIconTheme: const IconThemeData(color: Colors.white70), destinations: [for (final icon in icons) NavigationRailDestination(icon: Icon(icon), selectedIcon: Icon(icon), label: const SizedBox.shrink())]);
}

class _MobileLayout extends StatelessWidget {
  final List<String> titles; final List<IconData> icons; final int selectedIndex; final ValueChanged<int> onSelected;
  const _MobileLayout({required this.titles, required this.icons, required this.selectedIndex, required this.onSelected});
  @override
  Widget build(BuildContext context) { final primary = selectedIndex > 3 ? 0 : selectedIndex; return Scaffold(appBar: AppBar(title: const AurenzaWordmark(compact: true), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))]), body: _Page(title: titles[selectedIndex], index: selectedIndex), bottomNavigationBar: NavigationBar(selectedIndex: primary, onDestinationSelected: onSelected, destinations: const [NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'), NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'), NavigationDestination(icon: Icon(Icons.show_chart_outlined), label: 'Markets'), NavigationDestination(icon: Icon(Icons.menu), label: 'More')])); }
}

class _Page extends StatelessWidget {
  final String title; final int index;
  const _Page({required this.title, required this.index});
  @override
  Widget build(BuildContext context) {
    if (index == 0) return Column(children: [if (MediaQuery.sizeOf(context).width >= 700) _Header(title: title), const Expanded(child: DashboardScreen())]);
    if (index == 5) return Column(children: [if (MediaQuery.sizeOf(context).width >= 700) _Header(title: title), const Expanded(child: InvestmentProfitScreen())]);
    return Column(children: [if (MediaQuery.sizeOf(context).width >= 700) _Header(title: title), Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.construction_outlined, size: 48, color: AurenzaColors.gold), const SizedBox(height: 16), Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), const Text('Module foundation ready for backend implementation.')])))]);
  }
}

class _Header extends StatelessWidget {
  final String title; const _Header({required this.title});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AurenzaColors.border))), child: Row(children: [Text(title, style: Theme.of(context).textTheme.titleLarge), const Spacer(), const Icon(Icons.notifications_none), const SizedBox(width: 18), const CircleAvatar(backgroundColor: AurenzaColors.forest, child: Icon(Icons.person_outline, color: Colors.white))]));
}
