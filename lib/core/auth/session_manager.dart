import 'package:flutter/foundation.dart';
import 'package:kmb_app/features/auth/models/session.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';

class SessionManager {
  static Session? _session;
  static final ValueNotifier<Session?> sessionNotifier =
      ValueNotifier<Session?>(null);

  static Session? get session => _session;
  // static Session? get session => sessionNotifier.value;

  static void setSession(Session session) {
    _session = session;
    sessionNotifier.value = session;
  }

  static bool get isLoggedIn =>
      sessionNotifier.value != null && sessionNotifier.value!.jwt.isNotEmpty;

  static bool get isAdmin =>
      sessionNotifier.value?.activeRole == 'administrator';

  static bool get isChairman => sessionNotifier.value?.activeRole == 'chairman';

  static bool get isDealer => sessionNotifier.value?.activeRole == 'dealings';

  static bool get isExecutive =>
      sessionNotifier.value?.activeRole == 'executive officer';

  static String get homeRouteName {
    if (isAdmin) return 'admin_dashboard';
    if (isChairman) return 'chairman_dashboard';
    if (isDealer) return 'dealer_dashboard';
    if (isExecutive) return 'executive_dashboard';
    return 'login';
  }

  

  static Future<void> load() async {
    print('SessionManager.load() CALLED');
    final s = await SecureStorage.loadSession();
    print('Loaded session: $s');
    sessionNotifier.value = s;

    // sessionNotifier.value = await SecureStorage.loadSession();
  }

  static Future<void> clear() async {
    sessionNotifier.value = null;
    await SessionManager.clear();
    await SecureStorage.clearAll();
  }
}
