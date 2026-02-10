import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kmb_app/core/global/globals.dart';
// import 'package:kmb_app/features/ auth/models/user_model.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../features/auth/models/session.dart';





class SecureStorage {
  // ---------------- CONFIG ----------------
  static const _sessionKey = 'auth_session';
  static const _sessionTimestampKey = 'session_timestamp';
  // static const int _expiryDays = 1;
  //  static const int _expirySeconds = 5;
     static const int _expiryMinutes = 60;
     static int get expiryMinutes => _expiryMinutes;

  static final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ---------------- SINGLETON & AUTO LOGOUT ----------------
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal() {
    // _startAutoLogoutTimer();
  }

  static Timer? _autoLogoutTimer;
  static const _checkInterval = Duration(minutes: 5); // check every 10 seconds

  void _startAutoLogoutTimer() {
    
    
    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = Timer.periodic(_checkInterval, (_) async {

       final authProvider = Provider.of<AuthProvider>(rootNavigatorKey.currentContext!, listen: false);
  await authProvider.logout();
      final expired = await isExpired();
      if (expired) {
        debugPrint('Session Expired login out');
        await clearAll();
         rootNavigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }

  static Future<bool> isExpired() async {
    final timestamp = await getSessionTimestamp();
    if (timestamp == null) return true;
    final savedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(savedDate).inMinutes >= _expiryMinutes;

  }

  // ---------------- SAVE SESSION ----------------
  /// Saves session and sets timestamp to now.
  static Future<void> saveSession(Session session) async {
    debugPrint('SAVE SESSION CALLED');
debugPrint('SESSION JSON = ${jsonEncode(session.toJson())}');
    final now = DateTime.now().millisecondsSinceEpoch;
    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
    await _storage.write(key: _sessionTimestampKey, value: now.toString());

    //  AuthState.isLoggedIn.value = true;
  }

  // ---------------- LOAD SESSION ----------------
  /// Loads session if it exists and is not expired.
  /// Refreshes timestamp to extend active session.
  static Future<Session?> loadSession() async {
    try {
      final rawSession = await _storage.read(key: _sessionKey);
      final timestampStr = await _storage.read(key: _sessionTimestampKey);

        // 👇 ADD THESE DEBUG LINES
    debugPrint('LOAD SESSION CALLED');
    debugPrint('RAW SESSION = $rawSession');
    debugPrint('RAW TIMESTAMP = $timestampStr');

      if (rawSession == null || timestampStr == null) return null;

      final timestamp = int.tryParse(timestampStr);
      if (timestamp == null) {
        await clearAll();
        return null;
      }

      final savedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      if (now.difference(savedDate).inMinutes >= _expiryMinutes) {
        await clearAll();
        return null;
      }



      return Session.fromJson(jsonDecode(rawSession));
    } catch (e) {
      await clearAll();
      return null;
    }
  }

  // ---------------- GET SESSION (RAW) ----------------
  static Future<Session?> getSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;
    try {
      return Session.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

   static Future<int?> getSessionTimestamp() async {
    final ts = await _storage.read(key: _sessionTimestampKey);
    if (ts == null) return null;
    return int.tryParse(ts);
  }
  // ---------------- LOGIN STATE ----------------
  static Future<bool> isLoggedIn() async {
    final session = await loadSession();
    return session != null && session.jwt.isNotEmpty;
  }

  // ---------------- LOGOUT ----------------
  static Future<void> clearAll() async {

    // _autoLogoutTimer?.cancel();
    // _autoLogoutTimer = null;
    // await _storage.delete(key: _sessionKey);
    // await _storage.delete(key: _sessionTimestampKey);
      await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _sessionTimestampKey);

    //  AuthState.isLoggedIn.value = false;

    // await _storage.deleteAll();
  }

   static Future<bool> isSessionExpired() async {
    final ts = await _storage.read(key: _sessionTimestampKey);
    if (ts == null) return false;

    final timestamp = int.tryParse(ts);
    if (timestamp == null) return true;

    final saved = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(saved).inMinutes >= _expiryMinutes;
  }

  // ---------------- INTERNAL: REFRESH TIMESTAMP ----------------
  static Future<void> refreshTimestamp() async {
    final exists = await _storage.read(key: _sessionKey);
    if (exists != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await _storage.write(key: _sessionTimestampKey, value: now.toString());
    }
  }
  // static Future<AppUser> _refreshToken() async{
  // final acessToken =  
  // }




  static Future<int> secondsLeft() async {
  final ts = await getSessionTimestamp();
  if (ts == null) return 0;

  final saved = DateTime.fromMillisecondsSinceEpoch(ts);
  final diff = DateTime.now().difference(saved).inSeconds;

  final remaining = (_expiryMinutes * 60) - diff;
  return remaining > 0 ? remaining : 0;
}


static Future<int> secondsUntilExpiry() async {
  final timestamp =
      await _storage.read(key: _sessionTimestampKey);

  if (timestamp == null) return 0;

final saved =
    DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
final expiryTime = saved.add(Duration(minutes: _expiryMinutes));


  return expiryTime.difference(DateTime.now()).inSeconds;
}


}



