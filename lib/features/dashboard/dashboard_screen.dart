import 'package:flutter/material.dart';

import '../../config/supabase_config.dart';
import '../../core/backend/backend_service.dart';
import '../../core/theme/orenza_theme.dart';
import '../../core/widgets/system_states.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<BackendDashboard> _dashboard;

  @override
  void initState() {
    super.initState();
    _dashboard = _load();
  }

  Future<BackendDashboard> _load() {
    return BackendService.instance.getDashboard();
  }

  void _retry() {
    setState(() {
      _dashboard = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isConfigured) {
      return const AurenzaEmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Connect AURENZA Backend',
        message:
            'This application is intentionally not displaying fake '
            'financial data. Configure Supabase and the dashboard will '
            'load its results from the backend.',
      );
    }

    return FutureBuilder<BackendDashboard>(
      future: _dashboard,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AurenzaLoading(
            message: 'Loading your AURENZA account...',
          );
        }

        if (snapshot.hasError) {
          return AurenzaErrorState(
            message: snapshot.error.toString(),
            onRetry: _retry,
          );
        }

        final data = snapshot.data;

        if (data == null) {
          return const AurenzaEmptyState(
            title: 'No dashboard data',
            message: 'Your backend has not returned an account snapshot yet.',
          );
        }

        return _DashboardContent(data: data);
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final BackendDashboard data;

  const _DashboardContent({required this.data});

  String money(double value) {
    final sign = value < 0 ? '-' : '';
    return '$sign${data.currency} ${value.abs().toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Parent FutureBuilder will be recreated through normal navigation.
        // The backend remains the source of truth.
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.sandboxMode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: OrenzaColors.warningBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: OrenzaColors.gold.withValues(alpha: .35),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: OrenzaColors.warning,
                      size: 19,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'SANDBOX MODE — no live-money execution',
                        style: TextStyle(
                          color: OrenzaColors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 22),

            const Text(
              'AURENZA BROKER',
              style: TextStyle(
                color: OrenzaColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.6,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Your financial command center',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: OrenzaColors.charcoal,
              ),
            ),

            const SizedBox(height: 22),

            _HeroBalance(
              value: money(data.portfolioValue),
              currency: data.currency,
            ),

            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 850 ? 4 : 2;
                final gap = 12.0;
                final width =
                    (constraints.maxWidth - ((columns - 1) * gap)) / columns;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    _MetricCard(
                      width: width,
                      title: 'Balance',
                      value: money(data.balance),
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                    _MetricCard(
                      width: width,
                      title: 'Available',
                      value: money(data.available),
                      icon: Icons.account_balance_outlined,
                    ),
                    _MetricCard(
                      width: width,
                      title: 'Reserved',
                      value: money(data.reserved),
                      icon: Icons.lock_outline,
                    ),
                    _MetricCard(
                      width: width,
                      title: 'P&L',
                      value: money(data.pnl),
                      icon: Icons.trending_up,
                      positive: data.pnl >= 0,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: OrenzaColors.forestGreen,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        color: OrenzaColors.gold,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Backend-controlled account',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Financial values are supplied by AURENZA backend services.',
                            style: TextStyle(
                              color: OrenzaColors.slate,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.lock_outline, color: OrenzaColors.success),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBalance extends StatelessWidget {
  final String value;
  final String currency;

  const _HeroBalance({required this.value, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [OrenzaColors.forest, OrenzaColors.forestGreen],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL PORTFOLIO VALUE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            currency,
            style: const TextStyle(
              color: OrenzaColors.softGold,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
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
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: OrenzaColors.forestGreen,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: OrenzaColors.gold, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: OrenzaColors.slate,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: positive
                            ? OrenzaColors.success
                            : OrenzaColors.charcoal,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
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
