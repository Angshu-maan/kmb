class OTPValidator {
  static String? validateOTP(String otp, {int length = 6}) {
    if (otp.isEmpty) {
      return "OTP is required";
    }
    if (otp.length != length) {
      return "OTP must be $length digits";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      return "OTP must contain only numbers";
    }

    return null;
  }

  /// Validate individual OTP box input
  static bool isValidDigit(String value) {
    return RegExp(r'^[0-9]$').hasMatch(value);
  }
}
