import 'package:flutter/material.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/features/auth/models/role_switch.dart';

import '../api/auth_api.dart';
import '../../../core/storage/secure_storage.dart';
import 'package:kmb_app/features/auth/models/session.dart';



class AuthService {
  //send otp to mobile
  static Future<String> sendOtp(String phone) async {
    final response = await AuthApi.sendOtp(phone);

    if (response['status'] != 'success') {
      throw Exception(response['message']);
    }

    return response['data']['token'];
  }

  //verify otp and get toke
  static Future<String> verifyOtp({
    required String phone,
    required String otp,
    required String otpToken,
  }) async {
    final response = await AuthApi.verifyOtp(
      phone: phone,
      otp: otp,
      token: otpToken,
    );

    if (response['status'] != 'success') {
      throw Exception(response['message']);
    }

    final authToken = response['data']?['token'];

    if (authToken == null || authToken.toString().isEmpty) {
      throw Exception('Auth proof token missing');
    }

    // await SecureStorage.saveSession(
    //   authToken
    // );
    // await SecureStorage.saveSession(phone as Session);
    // await SecureStorage.saveSession('0' as Session);

    return authToken.toString();
  }

  static Future<Session> login({
    required String phone,
    required String authProofToken,
  }) async {
    final response = await AuthApi.login(
      phone: phone,
      authToken: authProofToken,
    );

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Login failed');
    }
    final data = response['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid server response');
    }
    final jwt = data['token'] as String?;
    // final refreshToken = data['refresh_token'] as String?;
    if (jwt == null || jwt.isEmpty) {
      throw Exception('Auth token missing');
    }
    // if (refreshToken == null || refreshToken.isEmpty){
    //   throw Exception('Refresh token missing');
    // }

    final roles = List<String>.from(data['roles'] ?? const []);
    const defaultRole = 'administrator';

    final activeRole =
        data['active_role'] as String? ??
        (roles.isNotEmpty ? roles.first : defaultRole);
    final userType = data['type'] as String? ?? defaultRole;
    final session = Session(
      jwt: jwt,
      // refreshToken: refreshToken,
      activeRole: activeRole,
      roles: roles,
      userType: userType,
    );

    // IMPORTANT: update session manager
    SessionManager.setSession(session);
    await SecureStorage.saveSession(session);

    return session;
  }

  // static Future<String> reLoggedIn({
  //   required String phone,
  //   required String refreshtoken,
  // }) async {
  //   final response = await AuthApi.reLogin(phone: phone, token: refreshtoken);

  //   if (response['status'] != 'success') {
  //     throw Exception(response['message']);
  //   }

  //   final res = response['data']?['token'];

  //   print('Relogin =>  $res');

  //   if (res == null || res.toString().isEmpty) {
  //     throw Exception('Auth proof token missing');
  //   }

  //   return res.toString();
  // }

  // static Future<String> reLoggedIn({
  //   required String phone,
  //   required String refreshtoken,
  // }) async {
  //   final response = await AuthApi.reLogin(phone: phone, token: refreshtoken);

  //   if (response['status'] != 'success') {
  //     throw Exception(response['message']);
  //   }

  //   final res = response['data']?['token'];

  //   print('Relogin =>  $res');

  //   if (res == null || res.toString().isEmpty) {
  //     throw Exception('Auth proof token missing');
  //   }

  //   return res.toString();
  // }


  static Future<String> switchRole({
    required String role,
    required String token,
  }) async {
    final response = await AuthApi.roleSwitch(
      token: token,
      role: role,
    );

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? "Role switch failed");
    }

    final newToken = response['data']?['token'];

    if (newToken == null || newToken.toString().isEmpty) {
      throw Exception("New token not received");
    }

    return newToken.toString();
  }

}
