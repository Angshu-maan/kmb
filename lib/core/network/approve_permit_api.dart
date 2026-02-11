import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';

class PermitService {
  static const _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> approvePermit({
    required int applicationRef,
    required String permitNumber,
    required String expiryDate,
    required String token,
  }) async {
    const endpoint = "approve";
    final url = "${ApiConfig.baseUrl}/$endpoint";

    final body = {
      "application_ref": applicationRef,
      "permit_number": permitNumber,
      "permit_expiry_date": expiryDate,
    };

    debugPrint("API POST URL => $url");
    debugPrint("API POST BODY => ${jsonEncode(body)}");

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
