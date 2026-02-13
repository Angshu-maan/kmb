// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:kmb_app/core/auth/session_manager.dart';
// import 'package:kmb_app/core/global/globals.dart';
// import 'package:kmb_app/features/auth/models/session.dart';
// import 'package:kmb_app/core/auth/user_role.dart';
// import 'package:kmb_app/core/storage/secure_storage.dart';
// import 'package:kmb_app/features/auth/services/auth_service.dart';

// UserRole mapRole(String role) {
//   switch (role) {
//     case 'administrator':
//       return UserRole.superAdmin;
//     case 'chairman':
//       return UserRole.chairman;
//     case 'executive officer':
//       return UserRole.executive;
//     case 'dealings':
//       return UserRole.dealing;
//     default:
//       throw Exception('Unknown role: $role');
//   }
// }



// class AuthProvider with ChangeNotifier, WidgetsBindingObserver {
//   bool _isLoggedIn = false;
//   Session? _session;
//   UserRole? _role;

//   Timer? _autoLogoutTimer;
//   // Timer? _countdownTimer;

//   int _secondsLeft = 0;
//   int get secondsLeft => _secondsLeft;

//   bool _showCountdown = false;
//   bool get showCountdown => _showCountdown;

//   bool get isLoggedIn => _isLoggedIn;
//   Session? get session => _session;
//   UserRole? get role => _role;

//   AuthProvider() {
//     WidgetsBinding.instance.addObserver(this);
//     _startAutoLogoutTimer();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _autoLogoutTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _checkSessionOnResume();
//       // _checkAndLogoutIfExpired();
//     }
//   }

//   Future<void> _checkSessionOnResume() async {
//     final expired = await SecureStorage.isSessionExpired();
//     if (expired) {
//       await logout(reason: "Session expired. Please login again.");
//     }
//   }

//   Future<void> login(Session session) async {
//     _session = session;
//     _role = mapRole(session.activeRole);
//     _isLoggedIn = true;
//     notifyListeners();

//     await SecureStorage.saveSession(session);
//     _startAutoLogoutTimer();
//   }

//   Future<void> loadSession() async {
//     final session = await SecureStorage.loadSession();
//     if (session != null) {
//       _session = session;
//       _role = mapRole(session.activeRole);
//       _isLoggedIn = true;
//       _startAutoLogoutTimer();
//     }
//     notifyListeners();
//   }

//   Future<void> logout({String? reason}) async {
//     await SecureStorage.clearAll();
//     _session = null;
//     _role = null;
//     _isLoggedIn = false;

//     _autoLogoutTimer?.cancel();
//     _autoLogoutTimer = null;
//     notifyListeners();


//     if (reason != null) {
//       rootScaffoldMessengerKey.currentState?.showSnackBar(
//         SnackBar(content: Text(reason), backgroundColor: Colors.black),
//       );
//     }
//   }

//   void _startAutoLogoutTimer() {
//     _autoLogoutTimer?.cancel();
//     _autoLogoutTimer = Timer.periodic(_dynamicInterval, (_) async {
//       final expired = await SecureStorage.isSessionExpired();

//       if (expired) {
//         await _checkAndLogoutIfExpired();
//         // await logout(reason: "Session expired. Please login again.");
//       }
//     });
//   }

//   Duration get _dynamicInterval {
//     final expiryMinutes = SecureStorage.expiryMinutes;
//     final expirySeconds = expiryMinutes * 90;

//     // Check 6 times during expiry period
//     final intervalSeconds = (expirySeconds / 6).round();

//     // Minimum 5 seconds, maximum 60 seconds
//     return Duration(seconds: intervalSeconds.clamp(5, 90));
//   }

//   Future<void> _checkAndLogoutIfExpired() async {
//     final expired = await SecureStorage.isSessionExpired();
//     if (expired) {
//       await logout(reason: "Session expired. Please login again.");
//     }
//   }

// // Future<void> switchRole(String newRole) async {
// //   if (_session == null) return;

// //   final newToken = await AuthService.switchRole(
// //     role: newRole,
// //     token: _session!.jwt,
// //   );

// //   final updatedSession = _session!.copyWith(
// //     jwt: newToken,
// //     activeRole: newRole,
// //   );

// //   _session = updatedSession;
// //   _role = mapRole(newRole);

// //   SessionManager.setSession(updatedSession);
// //   await SecureStorage.saveSession(updatedSession);

// //   notifyListeners();
// // }


// //  Session? _session;

// //   Session? get session => _session;

// Future<void> switchRole(String newRole) async {
//   if (_session == null) {
//     throw Exception("Session not found");
//   }

//   try {
//     final newToken = await AuthService.switchRole(
//       role: newRole,
//       token: _session!.jwt,
//     );

//     final updatedSession = _session!.copyWith(
//       jwt: newToken,
//       activeRole: newRole,
//     );

//     // ✅ Update EVERYTHING
//     _session = updatedSession;
//     _role = mapRole(newRole);     // 🔥 THIS WAS MISSING
//     _isLoggedIn = true;           // ensure it never becomes false

//     SessionManager.setSession(updatedSession);
//     await SecureStorage.saveSession(updatedSession);

//     notifyListeners();            // triggers GoRouter refresh
//   } catch (e) {
//     rethrow;
//   }
// }


// }





import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/core/global/globals.dart';
import 'package:kmb_app/features/auth/models/session.dart';
import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/features/auth/services/auth_service.dart';

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

class AuthProvider with ChangeNotifier, WidgetsBindingObserver {
  Session? _session;
  UserRole? _role;

  Timer? _autoLogoutTimer;

  // ================================
  // GETTERS
  // ================================

  bool get isLoggedIn => _session != null; // ✅ single source of truth
  Session? get session => _session;
  UserRole? get role => _role;

  // ================================
  // CONSTRUCTOR
  // ================================

  AuthProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoLogoutTimer?.cancel();
    super.dispose();
  }

  // ================================
  // LIFECYCLE
  // ================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSessionOnResume();
    }
  }

  Future<void> _checkSessionOnResume() async {
    final expired = await SecureStorage.isSessionExpired();
    if (expired) {
      await logout(reason: "Session expired. Please login again.");
    }
  }

  // ================================
  // LOGIN
  // ================================

  Future<void> login(Session session) async {
    _session = session;
    _role = mapRole(session.activeRole);

    await SecureStorage.saveSession(session);
    SessionManager.setSession(session);

    _startAutoLogoutTimer();
    notifyListeners();
  }

  // ================================
  // LOAD SESSION
  // ================================

  Future<void> loadSession() async {
    final session = await SecureStorage.loadSession();

    if (session != null) {
      _session = session;
      _role = mapRole(session.activeRole);
      _startAutoLogoutTimer();
    }

    notifyListeners();
  }

  // ================================
  // LOGOUT
  // ================================

  Future<void> logout({String? reason}) async {
    await SecureStorage.clearAll();

    _session = null;
    _role = null;

    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = null;

    notifyListeners();

    if (reason != null) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(reason),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  // ================================
  // AUTO LOGOUT
  // ================================

  void _startAutoLogoutTimer() {
    _autoLogoutTimer?.cancel();

    _autoLogoutTimer = Timer.periodic(_dynamicInterval, (_) async {
      final expired = await SecureStorage.isSessionExpired();
      if (expired) {
        await logout(reason: "Session expired. Please login again.");
      }
    });
  }

  Duration get _dynamicInterval {
    final expiryMinutes = SecureStorage.expiryMinutes;
    final expirySeconds = expiryMinutes * 90;

    final intervalSeconds = (expirySeconds / 6).round();

    return Duration(seconds: intervalSeconds.clamp(5, 90));
  }

  // ================================
  // SWITCH ROLE (WITHOUT LOGOUT)
  // ================================

  Future<void> switchRole(String newRole) async {
    if (_session == null) {
      throw Exception("Session not found");
    }

    final newToken = await AuthService.switchRole(
      role: newRole,
      token: _session!.jwt,
    );

    final updatedSession = _session!.copyWith(
      jwt: newToken,
      activeRole: newRole,
    );

    _session = updatedSession;
    _role = mapRole(newRole);

    SessionManager.setSession(updatedSession);
    await SecureStorage.saveSession(updatedSession);

    notifyListeners(); // 🔥 triggers GoRouter refresh safely
  }
}

