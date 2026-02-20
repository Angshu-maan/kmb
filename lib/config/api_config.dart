class ApiConfig {
  // static const String baseUrl =
  //     'http://gwkhrwng.qwertcorp.qc:8080/kmb_rickshaw/api/v1';

  static const String baseUrl =
      'http://lingdao.qwertcorp.qc:8080/kmb/dev/e_rickshaw/api/v1';

  static const String sendOtp = 'user/send/otp';
  static const String verifyOtp = 'user/verify/otp';
  static const String login = 'user/signin';
  static const String ownerList = 'owners/list';
  static const String driverList = 'drivers/list';
  static const String vehicleList = 'vehicles/list';
  static const String applicationList = 'applications/list';
  static const String viewDocument = 'uploads/view_document';
  static const String reLogin = 'user/relogin';
  static const String roleSwitch = 'user/role_switch';
  static const String approve = 'applications/approve';
  static const String permitIssue = 'applications/permit_issue';
  static const String permitNo = 'applications/set_permit_number';
}
