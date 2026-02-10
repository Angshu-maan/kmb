// import 'package:http/http.dart' as http;
// import 'package:kmb_app/core/storage/secure_storage.dart';
// import 'package:kmb_app/features/auth/services/auth_service.dart';

// class AuthHttpClient {
//   final http.Client _client = http.Client();

//   Future<http.Response> get(
//     Uri url, {
//     Map<String, String>? headers,
//   }) async {
//     return _send(
//       () => _client.get(url, headers: headers),
//     );
//   }

//   Future<http.Response> post(
//     Uri url, {
//     Map<String, String>? headers,
//     Object? body,
//   }) async {
//     return _send(
//       () => _client.post(url, headers: headers, body: body),
//     );
//   }

//   Future<http.Response> _send(
//     Future<http.Response> Function() request,
//   ) async {
//     final accessToken = await SecureStorage.getSession();

//     final response = await request().then(
//       (res) => res,
//     );

//     if (response.statusCode == 401) {
//       final refreshed = await AuthService.tryRefreshToken();

//       if (!refreshed) {
//         LockService.lock(); // 🔒 LOCK SCREEN
//         throw Exception('Session locked');
//       }

//       // Retry request after refresh
//       return request();
//     }

//     return response;
//   }
// }
