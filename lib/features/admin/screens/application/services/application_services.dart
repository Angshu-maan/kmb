import 'package:kmb_app/config/api_config.dart';
import 'package:kmb_app/core/network/api_client.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_response.dart';

class ApplicationServices {
  Future<ApplicationResponse> fetchDetails({String? token}) async {
    final response = await ApiService.get(
      ApiConfig.applicationList,
      token: token,
    );
    print('appliation.........$response');

    return ApplicationResponse.fromJson(response);
  }
}
