import 'package:flutter/foundation.dart';
import 'supabase_client.dart';

class BackendHealth extends ChangeNotifier {
  bool checking = false;
  bool available = false;
  String message = 'Backend status unknown';

  Future<void> check() async {
    checking = true;
    notifyListeners();

    try {
      await AurenzaSupabase.client
          .from('profiles')
          .select('id')
          .limit(1);

      available = true;
      message = 'Backend connected';
    } catch (e) {
      debugPrint('Backend health check failed: $e');
      available = false;
      message = 'Backend unavailable';
    }

    checking = false;
    notifyListeners();
  }
}
