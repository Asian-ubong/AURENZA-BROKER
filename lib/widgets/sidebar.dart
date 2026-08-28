import 'package:flutter/material.dart';

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
      (Icons.emoji_events_rounded, 'Challenges', 5),
      (Icons.leaderboard_rounded, 'Leaderboard', 6),
      (Icons.auto_awesome_outlined, 'AI Assistant', 7),
      (Icons.support_agent_outlined, 'Support', 8),
      (Icons.settings_outlined, 'Settings', 9),
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
              Expanded(
                child: ListView(
                  children: menuItems
                      .map((item) => _buildMenuItem(item.$1, item.$2, item.$3))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
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
