import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';

class PermitService {
  static const _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> approveNreject({
    required int applicationRef,
    String? summary,
    required String token,
  }) async {
    final url = "${ApiConfig.baseUrl}/${ApiConfig.approve}";

    final body = {
      "application_ref": applicationRef,
      if (summary != null) "summary": summary,
    };

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleJsonResponse(response);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } on http.ClientException {
      throw Exception("Network error. Check your connection.");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  static Future<Map<String, dynamic>> permitIssuednReject({
    required int applicationRef,
    required String permitNo,
    required int userRef,
    required String permitExpiryDate,
    required String token,
  }) async {
    final url = "${ApiConfig.baseUrl}/${ApiConfig.permitIssue}";

    final body = {
      "application_id": applicationRef,
      "user_ref": userRef,
      "permit_no": permitNo,
      "permit_expiry_date": permitExpiryDate,
    };

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleJsonResponse(response);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } on http.ClientException {
      throw Exception("Network error. Check your connection.");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  static Map<String, dynamic> _handleJsonResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception("Empty server response");
    }

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded['status'] == 'success') {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? "Server error");
      }
    }

    throw Exception(decoded['message'] ?? "Request failed");
  }
}
