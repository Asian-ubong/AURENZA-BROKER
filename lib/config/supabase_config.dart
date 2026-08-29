import 'package:flutter/foundation.dart';

class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  static void validate() {
    if (!isConfigured) {
      debugPrint(
        'SUPABASE NOT CONFIGURED: '
        'provide SUPABASE_URL and SUPABASE_ANON_KEY at build time.',
      );
    }
  }
}
