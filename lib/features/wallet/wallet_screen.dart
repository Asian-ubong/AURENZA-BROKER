import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/aurenza_colors.dart';
import '../../core/widgets/system_states.dart';

class WalletSnapshot {
  final Map<String, dynamic> data;
  const WalletSnapshot(this.data);

  double n(String key, [String? fallback]) {
    final value = data[key] ?? (fallback == null ? null : data[fallback]);
    return value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String s(String key, String fallback) => data[key]?.toString() ?? fallback;

  bool get sandbox => data['sandbox_mode'] == true;

  List<Map<String, dynamic>> get movements {
    final value = data['movements'];
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<WalletSnapshot> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<WalletSnapshot> _load() async {
    final client = Supabase.instance.client;
    if (client.auth.currentSession == null) {
      throw StateError('Authentication required.');
    }

    try {
      final result = await client.rpc('get_wallet_snapshot');
      final snapshot = _snapshotFrom(result);
      if (snapshot != null) return snapshot;
    } catch (_) {
      // Fall back to the existing dashboard RPC until the wallet RPC is live.
    }

    final result = await client.rpc('get_broker_dashboard');
    final snapshot = _snapshotFrom(result);
    if (snapshot != null) return snapshot;
    throw StateError('Backend returned no wallet data.');
  }

  WalletSnapshot? _snapshotFrom(dynamic result) {
    if (result is Map) {
      return WalletSnapshot(Map<String, dynamic>.from(result));
    }
    if (result is List && result.isNotEmpty && result.first is Map) {
      return WalletSnapshot(Map<String, dynamic>.from(result.first as Map));
    }
    return null;
  }

  void retry() => setState(() => future = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WalletSnapshot>(
      future: future,
      builder: (context, state) {
        if (state.connectionState == ConnectionState.waiting) {
          return const AurenzaLoading(message: 'Loading your wallet...');
        }
        if (state.hasError) {
          return AurenzaErrorState(
            message: state.error.toString(),
            onRetry: retry,
          );
        }

        final wallet = state.data!;
        final items = [
          (
            'Available balance',
            wallet.n('available_balance', 'available'),
            Icons.account_balance_outlined,
          ),
          (
            'Reserved balance',
            wallet.n('reserved_balance', 'reserved'),
            Icons.lock_outline,
          ),
          (
            'Sandbox capital',
            wallet.n('sandbox_capital'),
            Icons.shield_outlined,
          ),
          (
            'Trading balance',
            wallet.n('trading_balance', 'balance'),
            Icons.show_chart_outlined,
          ),
          ('Profit', wallet.n('profit', 'pnl'), Icons.trending_up),
          (
            'Withdrawable balance',
            wallet.n('withdrawable_balance'),
            Icons.payments_outlined,
          ),
        ];

        return RefreshIndicator(
          onRefresh: () async => retry(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AurenzaColors.forest, AurenzaColors.green],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WALLET',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${wallet.s('currency', 'USD')} ${wallet.n('total_balance', 'portfolio_value').toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      wallet.sandbox
                          ? 'SANDBOX MODE — backend controlled'
                          : 'LIVE ACCOUNT',
                      style: const TextStyle(
                        color: AurenzaColors.goldSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900 ? 3 : 2;
                  const gap = 12.0;
                  final width =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final item in items)
                        SizedBox(
                          width: width,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Icon(item.$3, color: AurenzaColors.gold),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.$1,
                                          style: const TextStyle(
                                            color: AurenzaColors.muted,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${wallet.s('currency', 'USD')} ${item.$2.toStringAsFixed(2)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              _section('Funding & payouts', [
                _row(
                  'Deposit status',
                  wallet.s('deposit_status', 'Not available'),
                ),
                _row(
                  'Payout status',
                  wallet.s('payout_status', 'Not available'),
                ),
              ]),
              const SizedBox(height: 20),
              _section(
                'Balance movements',
                wallet.movements.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            'No balance movements returned by the backend yet.',
                            style: TextStyle(color: AurenzaColors.muted),
                          ),
                        ),
                      ]
                    : [
                        for (final movement in wallet.movements)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              (movement['amount'] is num &&
                                      (movement['amount'] as num) >= 0)
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: AurenzaColors.gold,
                            ),
                            title: Text(
                              movement['description']?.toString() ??
                                  movement['type']?.toString() ??
                                  'Balance movement',
                            ),
                            subtitle: Text(
                              movement['status']?.toString() ?? 'recorded',
                            ),
                            trailing: Text(
                              movement['amount']?.toString() ?? '0',
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                      ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value.toUpperCase(),
        style: const TextStyle(
          color: AurenzaColors.gold,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
