import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
import 'package:kmb_app/config/api_config.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kmb_app/core/network/test_client.dart';

enum DocCategory { owner, driver }

enum DocType {
  passportPhoto,
  signature,
  panCard,
  aadharCard,
  voterId,
  drivingLicense,
  authorizationCertificate,
  insuranceCertificate,
  regdCertificate,
}

class DocumentHelper {
  static String _docKey(DocType type) {
    switch (type) {
      case DocType.passportPhoto:
        return 'passport_photo';
      case DocType.signature:
        return 'signature';
      case DocType.panCard:
        return 'pan_card';
      case DocType.aadharCard:
        return 'aadhar_card';
      case DocType.voterId:
        return 'voter_id';
      case DocType.drivingLicense:
        return 'driving_license';
      case DocType.authorizationCertificate:
        return 'authorization_certificate';
      case DocType.insuranceCertificate:
        return 'insurance_certificate';
      case DocType.regdCertificate:
        return 'registration_certificate';
    }
  }

  static bool isImage(DocType type) =>
      type == DocType.passportPhoto || type == DocType.signature;

  //   static Future<http.Response> fetch({
  //     required DocCategory category,
  //     required DocType type,
  //     required int id,
  //     String? token,
  //   }) {
  //     return TestApiService.post(ApiConfig.viewDocument, {
  //       "category": category.name,
  //       "file": _docKey(type),
  //       "id": id,
  //     }, token: token);
  //   }

  //   static Future<File> fetchPdf({
  //     required DocCategory category,
  //     required DocType type,
  //     required int id,
  //     String? token,
  //   }) async {
  //     final res = await fetch(
  //       category: category,
  //       type: type,
  //       id: id,
  //       token: token,
  //     );

  //     final dir = await getTemporaryDirectory();
  //     final file = File("${dir.path}/${_docKey(type)}_$id.pdf");
  //     await file.writeAsBytes(res.bodyBytes);

  //     return file;
  //   }
  // }

  static Future<Uint8List?> fetchBytes({
    required DocCategory category,
    required DocType type,
    required int id,
    String? token,
  }) async {
    final res = await TestApiService.post(ApiConfig.viewDocument, {
      "category": category.name,
      "file": _docKey(type),
      "id": id,
    }, token: token);

    // 🔥 CRITICAL DEBUG (you don't have this)
    debugPrint('DOC STATUS: ${res.statusCode}');
    debugPrint('DOC BODY: ${res.body}');

    if (res.statusCode != 200) return null;

    final dynamic decoded = jsonDecode(res.body);

    // if API sends something unexpected
    if (decoded is! Map<String, dynamic>) return null;

    if (decoded['status'] != 'success') return null;

    final data = decoded['data'];

    // 🚫 directory not found → []
    if (data == null || (data is List && data.isEmpty)) {
      return null;
    }

    // ✅ Case: base64 string
    if (data is String && data.isNotEmpty) {
      return base64Decode(data);
    }

    // ✅ Case: map with content
    if (data is Map && data['content'] != null) {
      return base64Decode(data['content']);
    }

    return null;
  }

  static Future<File?> fetchPdf({
    required DocCategory category,
    required DocType type,
    required int id,
    String? token,
  }) async {
    final bytes = await fetchBytes(
      category: category,
      type: type,
      id: id,
      token: token,
    );

    if (bytes == null) return null;

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/${_docKey(type)}_$id.pdf");
    await file.writeAsBytes(bytes);

    return file;
  }
}
