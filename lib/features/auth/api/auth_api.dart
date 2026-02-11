import '../../../core/network/api_client.dart';
import '../../../config/api_config.dart';

class AuthApi {
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await ApiService.post(ApiConfig.sendOtp, {
      "phone_number": phone,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? "Failed to send OTP");
    }

    return response;
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
    required String token,
  }) async {
    final response = await ApiService.post(ApiConfig.verifyOtp, {
      "phone": phone,
      "otp": otp,
      "token": token,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'OTP verification failed');
    }

    return response;
  }

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String authToken,
  }) async {
    final response = await ApiService.post(ApiConfig.login, {
      "phone_no": phone,
      "token": authToken,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Login failed');
    }

    return response;
  }

  static Future<Map<String, dynamic>> resendOtp({
    required String phone,
    required String token,
  }) async {
    final response = await ApiService.post(ApiConfig.sendOtp, {
      "phone_number": phone,
      "token": token,
    });

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to resend OTP');
    }

    return response;
  }

  static Future<Map<String, dynamic>> reLogin({
    required String phone,
    required String token,
  }) async {
    final response = await ApiService.post(ApiConfig.reLogin, {
      "phone_number": phone,
      "token": token,
    });

    // if (kDebugMode) {
    //   debugPrint('reLogin => $response');
    // }

    if (response['status'] != 'success') {
      throw Exception(response['message'] ?? 'Failed to resend OTP');
    }

    return response;
  }
}
