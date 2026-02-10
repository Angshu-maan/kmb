import '../model/application_model.dart';

import 'application_services.dart';
import 'package:kmb_app/core/auth/auth_session_helper.dart';

class ApplicationRepository {
  Future<List<ApplicationModel>> getApplications() async {
    final token = await AuthSessionHelper.getAuthToken();
    final response = await ApplicationApi.fetchOwners(token: token);

    final rawData = response['data'];

    if (rawData == null || rawData is! List) {
      return [];
    }

    return rawData
        .map<ApplicationModel>((e) => ApplicationModel.fromJson(e))
        .toList();
  }
}
