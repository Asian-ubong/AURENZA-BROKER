import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/aurenza_colors.dart';
import '../../core/widgets/system_states.dart';

class AdminFinanceScreen extends StatefulWidget {
  const AdminFinanceScreen({super.key});

  @override
  State<AdminFinanceScreen> createState() => _AdminFinanceScreenState();
}

class _AdminFinanceScreenState extends State<AdminFinanceScreen> {
  late Future<Map<String, dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    final client = Supabase.instance.client;
    if (client.auth.currentSession == null) {
      throw StateError('Authentication required.');
    }
    final result = await client.rpc('get_admin_wallet_overview');
    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }
    if (result is List && result.isNotEmpty && result.first is Map) {
      return Map<String, dynamic>.from(result.first as Map);
    }
    throw StateError('Backend returned no admin wallet data.');
  }

  void retry() => setState(() => future = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: future,
      builder: (context, state) {
        if (state.connectionState == ConnectionState.waiting) {
          return const AurenzaLoading(message: 'Loading finance controls...');
        }
        if (state.hasError) {
          return AurenzaErrorState(
            message:
                'Backend wallet data is not available yet. Apply the wallet SQL contract to Supabase, then refresh this screen.',
            onRetry: retry,
          );
        }

        final data = state.data!;
        final company = data['company_wallet'];
        final users = data['user_wallets'];

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Company & User Wallets',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Company treasury is a separate wallet. Each customer has an individual wallet and ledger.',
            ),
            const SizedBox(height: 22),
            _CompanyWalletCard(company: company),
            const SizedBox(height: 22),
            const Text(
              'Customer wallets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            if (users is List && users.isNotEmpty)
              for (final user in users.whereType<Map>())
                _UserWalletTile(user: Map<String, dynamic>.from(user))
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No customer wallets returned.'),
                ),
              ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.lock_outline, color: AurenzaColors.gold),
                title: Text('Withdrawal safety'),
                subtitle: Text(
                  'Every withdrawal must resolve the requesting user ID to that exact customer wallet and its withdrawable balance. Never use another customer wallet as a source.',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CompanyWalletCard extends StatelessWidget {
  final dynamic company;
  const _CompanyWalletCard({required this.company});

  double n(String key) {
    if (company is! Map) return 0;
    final value = (company as Map)[key];
    return value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_outlined, color: AurenzaColors.gold),
                SizedBox(width: 10),
                Text(
                  'COMPANY WALLET',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '\$${n('balance').toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text('Separate from all customer wallets.'),
          ],
        ),
      ),
    );
  }
}

class _UserWalletTile extends StatelessWidget {
  final Map<String, dynamic> user;
  const _UserWalletTile({required this.user});

  double n(String key) =>
      (user[key] as num?)?.toDouble() ??
      double.tryParse(user[key]?.toString() ?? '0') ??
      0;

  @override
  Widget build(BuildContext context) {
    final initial = (user['display_name'] ?? 'U')
        .toString()
        .substring(0, 1)
        .toUpperCase();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: CircleAvatar(child: Text(initial)),
        title: Text(user['display_name']?.toString() ?? 'User'),
        subtitle: Text(
          user['email']?.toString() ??
              user['user_id']?.toString() ??
              'Customer',
        ),
        trailing: Text(
          '\$${n('available_balance').toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        children: [
          Row(
            children: [
              Expanded(child: _stat('Wallet ID', user['wallet_id'])),
              Expanded(
                child: _stat(
                  'Available',
                  '\$${n('available_balance').toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _stat(
                  'Withdrawable',
                  '\$${n('withdrawable_balance').toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AurenzaColors.muted),
        ),
        const SizedBox(height: 4),
        Text(
          value?.toString() ?? '—',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
