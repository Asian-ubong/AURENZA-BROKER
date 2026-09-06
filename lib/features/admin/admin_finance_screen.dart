import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/aurenza_colors.dart';

class AdminFinanceScreen extends StatefulWidget {
  const AdminFinanceScreen({super.key});

  @override
  State<AdminFinanceScreen> createState() => _AdminFinanceScreenState();
}

class _AdminFinanceScreenState extends State<AdminFinanceScreen> {
  Future<Map<String, dynamic>> _load() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) throw StateError('Sign in with an authorized admin account.');
    final result = await Supabase.instance.client.rpc('get_admin_wallet_overview');
    if (result is! Map) throw StateError('Admin wallet data is unavailable.');
    return Map<String, dynamic>.from(result);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _StateCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Company & User Wallets',
            message: 'Backend wallet data is not available yet. Apply the wallet SQL contract to Supabase, then refresh this screen.',
            error: snapshot.error.toString(),
            onRetry: () => setState(() {}),
          );
        }

        final data = snapshot.data ?? const {};
        final company = Map<String, dynamic>.from(data['company_wallet'] as Map? ?? const {});
        final users = ((data['user_wallets'] as List?) ?? const [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.all(28),
            children: [
              const Text('Finance Control Center', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Company treasury and customer wallets are strictly separated. Customer money can only be monitored against the wallet belonging to that exact customer.'),
              const SizedBox(height: 24),
              _CompanyWalletCard(wallet: company),
              const SizedBox(height: 28),
              Row(children: [
                const Expanded(child: Text('User Wallets', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
                Chip(label: Text('${users.length} users')),
              ]),
              const SizedBox(height: 12),
              if (users.isEmpty)
                const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('No customer wallets yet. A wallet is created automatically for each authenticated user and starts at zero.')))
              else
                ...users.map((user) => _UserWalletTile(user: user)),
            ],
          ),
        );
      },
    );
  }
}

class _CompanyWalletCard extends StatelessWidget {
  final Map<String, dynamic> wallet;
  const _CompanyWalletCard({required this.wallet});

  double n(String key) => (wallet[key] as num?)?.toDouble() ?? double.tryParse('${wallet[key] ?? 0}') ?? 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AurenzaColors.forest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.account_balance, color: AurenzaColors.gold),
            SizedBox(width: 10),
            Text('COMPANY WALLET', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 1)),
            Spacer(),
            Chip(label: Text('COMPANY', style: TextStyle(fontSize: 11))),
          ]),
          const SizedBox(height: 20),
          Text('${wallet['currency'] ?? 'USD'} ${n('total_balance').toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Wrap(spacing: 22, runSpacing: 12, children: [
            _Metric('Available', n('available_balance')),
            _Metric('Reserved', n('reserved_balance')),
            _Metric('Trading', n('trading_balance')),
            _Metric('Profit', n('profit_balance')),
            _Metric('Withdrawable', n('withdrawable_balance')),
          ]),
          const SizedBox(height: 18),
          const Text('This wallet belongs to AURENZA company treasury. It is not a customer wallet and must never be selected as a customer withdrawal source.', style: TextStyle(color: Colors.white70)),
        ]),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final double value;
  const _Metric(this.label, this.value);

  @override
  Widget build(BuildContext context) => SizedBox(width: 130, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 3),
        Text('\$${value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ]));
}

class _UserWalletTile extends StatelessWidget {
  final Map<String, dynamic> user;
  const _UserWalletTile({required this.user});

  double n(String key) => (user[key] as num?)?.toDouble() ?? double.tryParse('${user[key] ?? 0}') ?? 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: CircleAvatar(child: Text('${(user['display_name'] ?? 'U').toString().substring(0, 1).toUpperCase()}')),
        title: Text(user['display_name']?.toString() ?? 'User'),
        subtitle: Text(user['email']?.toString() ?? user['user_id']?.toString() ?? 'Customer'),
        trailing: Text('\$${n('available_balance').toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900)),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        children: [
          Row(children: [
            Expanded(child: _UserMetric('Total', n('total_balance'))),
            Expanded(child: _UserMetric('Reserved', n('reserved_balance'))),
            Expanded(child: _UserMetric('Profit', n('profit_balance'))),
            Expanded(child: _UserMetric('Withdrawable', n('withdrawable_balance'))),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: Text('Deposit: ${user['deposit_status'] ?? 'none'}')),
            Expanded(child: Text('Payout: ${user['payout_status'] ?? 'none'}')),
          ]),
          const SizedBox(height: 10),
          Text('User ID: ${user['user_id'] ?? '—'}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          const Text('Withdrawal rule: approve only against this exact user wallet and its withdrawable balance. Never use another user wallet.', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _UserMetric extends StatelessWidget {
  final String label;
  final double value;
  const _UserMetric(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text('\$${value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800)),
      ]);
}

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String error;
  final VoidCallback onRetry;
  const _StateCard({required this.icon, required this.title, required this.message, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(child: Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 48, color: AurenzaColors.gold),
        const SizedBox(height: 14),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(error, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 18),
        FilledButton(onPressed: onRetry, child: const Text('Refresh')),
      ]))));
}
