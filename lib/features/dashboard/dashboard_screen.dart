import 'package:flutter/material.dart';
import '../../core/theme/orenza_theme.dart';
import '../../core/widgets/sandbox_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SandboxBanner(),
          const SizedBox(height: 28),

          const Text(
            'Good afternoon',
            style: TextStyle(color: OrenzaColors.slate, fontSize: 14),
          ),

          const SizedBox(height: 6),

          const Text(
            'Your Broker Dashboard',
            style: TextStyle(
              color: OrenzaColors.charcoal,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > 900
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _MetricCard(
                    width: width,
                    title: 'Sandbox Capital',
                    value: '\$200.00',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  _MetricCard(
                    width: width,
                    title: 'Available',
                    value: '\$150.00',
                    icon: Icons.account_balance_outlined,
                  ),
                  _MetricCard(
                    width: width,
                    title: 'Reserved',
                    value: '\$50.00',
                    icon: Icons.lock_outline,
                  ),
                  _MetricCard(
                    width: width,
                    title: 'Trading P&L',
                    value: '+\$30.00',
                    icon: Icons.trending_up,
                    positive: true,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          const _PortfolioCard(),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.show_chart,
                  title: 'Markets',
                  subtitle: 'Explore test markets',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _QuickAction(
                  icon: Icons.swap_vert,
                  title: 'Trading',
                  subtitle: 'Open a test trade',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final bool positive;

  const _MetricCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: OrenzaColors.forestGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: OrenzaColors.gold, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: OrenzaColors.slate,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: TextStyle(
                        color: positive
                            ? OrenzaColors.emerald
                            : OrenzaColors.charcoal,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Portfolio Overview',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                Spacer(),
                Icon(Icons.more_horiz, color: OrenzaColors.slate),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '\$230.00',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sandbox portfolio value',
              style: TextStyle(color: OrenzaColors.slate),
            ),
            const SizedBox(height: 20),
            Container(
              height: 7,
              decoration: BoxDecoration(
                color: OrenzaColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: .68,
                child: Container(
                  decoration: BoxDecoration(
                    color: OrenzaColors.forestGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward_ios,
              color: OrenzaColors.gold,
              size: 16,
            ),
            const SizedBox(width: 14),
            Icon(icon, color: OrenzaColors.forestGreen, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: OrenzaColors.slate,
                      fontSize: 12,
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
