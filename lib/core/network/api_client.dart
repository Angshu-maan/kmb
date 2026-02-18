import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../../config/api_config.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = "${ApiConfig.baseUrl}/$endpoint";
    debugPrint("API POST URL => $url");
    debugPrint("API POST BODY => $body");
    debugPrint("API POST header token => $token");
    try {
      final response = await http
          .post(
            Uri.parse(url),

            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
              // "X-Client-Type":"android"
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  static Future<Map<String, dynamic>> roleSwitch(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = "${ApiConfig.baseUrl}/$endpoint";
    debugPrint("API POST URL => $url");
    debugPrint("API POST BODY => $body");
    debugPrint("API POST header token => $token");
    try {
      final response = await http
          .post(
            Uri.parse(url),

            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authentication": "Bearer $token",
              "X-Client-Type": "android",
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    final url = "${ApiConfig.baseUrl}/$endpoint";
    debugPrint("API GET URL => $url");

    try {
      final response = await http
          .get(
            Uri.parse(url),

            headers: {
              "Content-Type": "application/json",
              'X-Client-Type': 'android',
              if (token != null) "Authentication": "Bearer $token",
            },
          )
          .timeout(_timeout);

      print('Get response ${response}');

      return _handleResponse(response);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (response.body.isEmpty) {
      throw Exception("Empty server response");
    }

    final decoded = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    final message =
        decoded['message'] ??
        decoded['error'] ??
        decoded['status'] ??
        "Something went wrong";

    throw Exception("Error $statusCode: $message");
  }

  // static Map<String,dynamic> _refreshToken(){

  // }
}
