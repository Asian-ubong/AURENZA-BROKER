import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BackendDashboard {
  final double balance;
  final double available;
  final double reserved;
  final double pnl;
  final double portfolioValue;
  final String currency;
  final bool sandboxMode;

  const BackendDashboard({
    required this.balance,
    required this.available,
    required this.reserved,
    required this.pnl,
    required this.portfolioValue,
    required this.currency,
    required this.sandboxMode,
  });

  factory BackendDashboard.fromMap(Map<String, dynamic> data) {
    double number(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    return BackendDashboard(
      balance: number(data['balance']),
      available: number(data['available']),
      reserved: number(data['reserved']),
      pnl: number(data['pnl']),
      portfolioValue: number(data['portfolio_value']),
      currency: data['currency']?.toString() ?? 'USD',
      sandboxMode: data['sandbox_mode'] == true,
    );
  }
}

class BackendService {
  BackendService._();

  static final BackendService instance = BackendService._();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> bootstrapUser() async {
    if (client.auth.currentSession == null) {
      throw StateError('Authentication required.');
    }

    await client.rpc('bootstrap_aurenza_user');
  }

  Future<BackendDashboard> getDashboard() async {
    if (client.auth.currentSession == null) {
      throw StateError('Authentication required.');
    }

    final response = await client.rpc('get_broker_dashboard');

    if (response is Map<String, dynamic>) {
      return BackendDashboard.fromMap(response);
    }

    if (response is List && response.isNotEmpty) {
      final first = response.first;

      if (first is Map<String, dynamic>) {
        return BackendDashboard.fromMap(first);
      }
    }

    throw StateError('Backend returned no dashboard data.');
  }

  Future<bool> checkBackend() async {
    try {
      await client.rpc('get_backend_health');
      return true;
    } catch (error) {
      debugPrint('AURENZA backend health check failed: $error');
      return false;
    }
  }
}
