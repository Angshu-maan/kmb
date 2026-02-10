import 'package:kmb_app/core/storage/secure_storage.dart';

class AuthSessionHelper {
  static Future<String> getAuthToken() async {
    final session = await SecureStorage.getSession();
    if (session == null) {
      throw Exception('Not logged in');
    }
    return session.jwt;
  }
}
