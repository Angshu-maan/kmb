import 'package:flutter/foundation.dart';

class RoleRouter {
  static const String adminDashboard = 'admin_dashboard';
  static const String executiveDashboard = 'executive_dashboard';
  static const String dealerDashboard = 'dealer_dashboard';
  static const String chairmanDashboard = 'chairman_dashboard';
  static const String login = 'login';

  static String homeRouteForRole(String role) {
    final r = role.toLowerCase().trim();

    switch (r) {
      case 'administrator':
        return adminDashboard;

      case 'executive':
      case 'executive officer':
        return executiveDashboard;

      case 'dealer':
      case 'dealing':
        return dealerDashboard;

      case 'chairman':
        return chairmanDashboard;

      default:
        debugPrint('⚠️ Unknown role received: $role');
        return login;
    }
  }
}
