import 'package:flutter/material.dart';
import 'package:kmb_app/core/auth/auth_session_helper.dart';
import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/core/network/approve_permit_api.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';

class ApplicationProvider with ChangeNotifier {
  final AuthProvider authProvider;

  ApplicationProvider(this.authProvider);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> updateApplicationStatus({
    required int applicationId,
    required ApplicationAction action,
    String? reason,
    String? permitNo,
    String? permitExpiry,
  }) async {
    final role = authProvider.role;
    final token = AuthSessionHelper.getAuthToken();
    final user = authProvider.user;

    if (role == null || user == null) {
      throw Exception("User not authenticated");
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (role == UserRole.dealing) {
        await PermitService.permitIssuednReject(
          applicationRef: applicationId,
          permitNo: permitNo!,
          userRef: user.id,
          permitExpiryDate: permitExpiry!,
          token: token.toString(),
        );
      } else {
        await PermitService.approveNreject(
          applicationRef: applicationId,
          summary: reason,
          token: token.toString(),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
