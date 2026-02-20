import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:kmb_app/core/auth/auth_session_helper.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_response.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_services.dart';

// import 'dart:convert';
class ApplicationRepository {
  final ApplicationService _service;

  ApplicationRepository(this._service);

  Future<ApplicationResponse> getApplications({
    required int page,
    required int limit,
  }) async {
    final token = await AuthSessionHelper.getAuthToken();

    return await _service.fetchApplications(
      token: token,
      page: page,
      limit: limit,
    );
  }
}
