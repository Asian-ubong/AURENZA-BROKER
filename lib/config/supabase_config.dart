import 'package:flutter/foundation.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool get isConfigured =>
      url.trim().isNotEmpty && publishableKey.trim().isNotEmpty;

  static void validate() {
    if (!isConfigured) {
      debugPrint(
        'AURENZA: Supabase is not configured. '
        'Backend-dependent features remain unavailable.',
      );
    }
  }

  static void logStatus() {
    if (isConfigured) {
      debugPrint('AURENZA: Supabase configuration detected.');
    } else {
      debugPrint(
        'AURENZA: Supabase is not configured. '
        'The application will remain in backend-unavailable mode.',
      );
    }
  }
}
