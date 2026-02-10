import 'package:kmb_app/core/network/api_client.dart';

class ApplicationApi {
  static Future<Map<String, dynamic>> fetchOwners({
    required String token,
  }) {
    return ApiService.post(
      'applications/list',
      {},
      token: token,
    );
  }
}
