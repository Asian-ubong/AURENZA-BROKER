import 'package:supabase_flutter/supabase_flutter.dart';

/// Client-side routing hint only. Real authorization must remain in Supabase
/// RLS / SECURITY DEFINER functions and backend policies.
class AurenzaAdminAccess {
  const AurenzaAdminAccess._();

  static const allowedRoles = <String>{
    'super_admin',
    'admin',
    'compliance',
    'risk_manager',
    'support',
  };

  static String? get role {
    final user = Supabase.instance.client.auth.currentUser;
    final value = user?.appMetadata['role'];
    return value is String ? value : null;
  }

  static bool get isAdmin => role != null && allowedRoles.contains(role);
}
