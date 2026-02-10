import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../../config/api_config.dart';

class ApiTestService {
  static const Duration _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    String? token,
  }) async {
    final url = "${ApiConfig.baseUrl}/$endpoint";
    // debugPrint("API POST URL => $url");
    // debugPrint("token: ${token}");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
               'X-Client-Type': 'mobile',
              if (token != null) "Authentication": "Bearer $token",
            },
          )
          .timeout(_timeout);
        

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
    debugPrint(response.body.toString());

    final decoded = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    final message = decoded[''] ?? "Something went wrong";
    throw Exception("Error $statusCode: $message");
  }
}
