import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:kmb_app/core/auth/auth_session_helper.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_services.dart';
// import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApplicationRepository {
  final ApplicationServices _service = ApplicationServices();

  Future<List<ApplicationModel>> getApplications() async {
    try {
      final token = await AuthSessionHelper.getAuthToken();
      print('JWT  TOKEN => $token');

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print("DECODED TOKEN => $decodedToken");
      print("ROLES => ${decodedToken['roles']}");
      print("ACTIVE ROLE => ${decodedToken['active_role']}");
      final response = await _service.fetchDetails(token: token);
      print('${response.data}');
      debugPrint('${response.data}');

      return response.data
          .map<ApplicationModel>((e) => ApplicationModel.fromJson(e))
          .toList();
    } catch (e) {
      print('ApplicatioRepository error: $e');
      return [];
    }
  }
}
