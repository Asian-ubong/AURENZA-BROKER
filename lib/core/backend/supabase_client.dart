import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/supabase_config.dart';

abstract final class AurenzaSupabase {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<bool> initialize() async {
    if (!SupabaseConfig.isConfigured) {
      SupabaseConfig.validate();
      return false;
    }

    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );

    return true;
  }
}
