import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kmb_app/core/global/globals.dart';
import 'package:kmb_app/features/auth/models/session.dart';
import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';

UserRole mapRole(String role) {
  switch (role) {
    case 'administrator':
      return UserRole.superAdmin;
    case 'chairman':
      return UserRole.chairman;
    case 'executive officer':
      return UserRole.executive;
    case 'dealings':
      return UserRole.dealing;
    default:
      throw Exception('Unknown role: $role');
  }
}

// class AuthProvider with ChangeNotifier {
//   bool _isLoggedIn = false;
//   Session? _session;
//   UserRole? _role;

//   bool get isLoggedIn => _isLoggedIn;
//   Session? get session => _session;
//   UserRole? get role => _role;

//   Timer? _autoLogoutTimer;
//   static const int _expiryMinutes = 10; // session expiry duration

//   // ---------------- LOGIN ----------------
//   Future<void> login(Session session) async {
//     _session = session;
//     _role = mapRole(session.activeRole);
//     _isLoggedIn = true;

//     // Save session in secure storage
//     await SecureStorage.saveSession(session);

//     // Start auto-logout timer
//     _startAutoLogoutTimer();

//     notifyListeners();
//   }

//   // ---------------- LOAD SESSION ----------------
//   Future<void> loadSession() async {
//     final session = await SecureStorage.getSession();
//     if (session != null) {
//       _session = session;
//       _role = mapRole(session.activeRole);
//       _isLoggedIn = true;

//       // Start auto-logout timer for remaining session time
//       _startAutoLogoutTimer();
//     }
//     notifyListeners();
//   }

//   // ---------------- LOGOUT ----------------
//   Future<void> logout({bool showSnackbar = true}) async {
//     await SecureStorage.clearAll();
//     _session = null;
//     _role = null;
//     _isLoggedIn = false;
//     _autoLogoutTimer?.cancel();
//     _autoLogoutTimer = null;
//     notifyListeners();

//     // Optional: show a global snackbar
//     if (showSnackbar && rootScaffoldMessengerKey.currentState != null) {
//       rootScaffoldMessengerKey.currentState!.showSnackBar(
//         const SnackBar(
//           content: Text('Session expired. Please login again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // ---------------- AUTO LOGOUT TIMER ----------------
//   void _startAutoLogoutTimer() async {
//     _autoLogoutTimer?.cancel();

//     final expired = await SecureStorage.isExpired();
//     if (expired) {
//       logout();
//       return;
//     }

//     // Calculate remaining duration
//     final timestamp = await SecureStorage.getSessionTimestamp();
//     if (timestamp == null) return;

//     final savedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
//     final remaining = Duration(minutes: _expiryMinutes) - DateTime.now().difference(savedDate);

//     if (remaining.isNegative) {
//       logout();
//       return;
//     }

//     _autoLogoutTimer = Timer(remaining, () async {
//       await logout();
//     });
//   }
// }

class AuthProvider with ChangeNotifier, WidgetsBindingObserver {
  bool _isLoggedIn = false;
  Session? _session;
  UserRole? _role;

  Timer? _autoLogoutTimer;
  // Timer? _countdownTimer;

  int _secondsLeft = 0;
  int get secondsLeft => _secondsLeft;

  bool _showCountdown = false;
  bool get showCountdown => _showCountdown;

  bool get isLoggedIn => _isLoggedIn;
  Session? get session => _session;
  UserRole? get role => _role;

  AuthProvider() {
    WidgetsBinding.instance.addObserver(this);
    _startAutoLogoutTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoLogoutTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSessionOnResume();
      // _checkAndLogoutIfExpired();
    }
  }

  Future<void> _checkSessionOnResume() async {
    final expired = await SecureStorage.isSessionExpired();
    if (expired) {
      await logout(reason: "Session expired. Please login again.");
    }
  }

  Future<void> login(Session session) async {
    _session = session;
    _role = mapRole(session.activeRole);
    _isLoggedIn = true;
    notifyListeners();

    await SecureStorage.saveSession(session);
    _startAutoLogoutTimer();
  }

  Future<void> loadSession() async {
    final session = await SecureStorage.loadSession();
    if (session != null) {
      _session = session;
      _role = mapRole(session.activeRole);
      _isLoggedIn = true;
      _startAutoLogoutTimer();
    }
    notifyListeners();
  }

  Future<void> logout({String? reason}) async {
    await SecureStorage.clearAll();
    _session = null;
    _role = null;
    _isLoggedIn = false;

    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = null;

    notifyListeners();

    if (reason != null) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(reason), backgroundColor: Colors.black),
      );
    }
  }

  void _startAutoLogoutTimer() {
    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = Timer.periodic(_dynamicInterval, (_) async {
      final expired = await SecureStorage.isSessionExpired();

      if (expired) {
        await _checkAndLogoutIfExpired();
        // await logout(reason: "Session expired. Please login again.");
      }
    });
  }

  Duration get _dynamicInterval {
    final expiryMinutes = SecureStorage.expiryMinutes;
    final expirySeconds = expiryMinutes * 90;

    // Check 6 times during expiry period
    final intervalSeconds = (expirySeconds / 6).round();

    // Minimum 5 seconds, maximum 60 seconds
    return Duration(seconds: intervalSeconds.clamp(5, 90));
  }

  Future<void> _checkAndLogoutIfExpired() async {
    final expired = await SecureStorage.isSessionExpired();
    if (expired) {
      await logout(reason: "Session expired. Please login again.");
    }
  }
}
