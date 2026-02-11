import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';

class TestApiService {
  static const Duration _timeout = Duration(seconds: 15);

  /// -------------------- POST (JSON ONLY) --------------------
  // static Future<Map<String, dynamic>> post(
  //   String endpoint,
  //   Map<String, dynamic> body, {
  //   String? token,
  // }) async {
  //   final url = "${ApiConfig.baseUrl}/$endpoint";
  //   debugPrint("API POST URL => $url");
  //   debugPrint("API POST BODY => ${jsonEncode(body)}");

  //   try {
  //     final response = await http
  //         .post(
  //           Uri.parse(url),
  //           headers: {
  //             "Content-Type": "application/json",
  //             if (token != null) "Authorization": "Bearer $token",
  //           },
  //           body: jsonEncode(body),
  //         )
  //         .timeout(_timeout);

  //     return _handleJsonResponse(response);
  //   } on TimeoutException {
  //     throw Exception("Request timeout");
  //   }
  // }

  /// -------------------- GET (JSON ONLY) --------------------
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
              if (token != null) "Authorization": "Bearer $token",
            },
          )
          .timeout(_timeout);

      return _handleJsonResponse(response);
    } on TimeoutException {
      throw Exception("Request timeout");
    }
  }

  /// -------------------- POST (BINARY ONLY) --------------------
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = "${ApiConfig.baseUrl}/$endpoint";
    debugPrint("API POST  URL => $url");
    debugPrint("API POST  BODY => ${jsonEncode(body)}");

    final response = await http
        .post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Binary fetch failed (${response.statusCode})");
    }

    return response;
  }

  /// -------------------- JSON HANDLER --------------------
  static Map<String, dynamic> _handleJsonResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception("Empty server response");
    }

    late final Map<String, dynamic> decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception("Invalid JSON response");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(decoded['message'] ?? "Server error");
  }

  static Future<void> approvePermit({
    required int applicationId,
    required String permitNumber,
    required String expiryDate,
  }) async {}
}
