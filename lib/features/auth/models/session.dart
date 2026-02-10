class Session {
  final String jwt;
  // final String refreshToken;
  final String activeRole;
  final List<String> roles;
  final String userType;

  const Session({
    required this.jwt,
    // required this.refreshToken,
    required this.activeRole,
    required this.roles,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'jwt': jwt,
      // 'refreshToken': refreshToken,
      'activeRole': activeRole,
      'roles': roles,
      'userType': userType,
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      jwt: json['jwt'] as String,
      // refreshToken: json['refreshToken'] as String,
      activeRole: json['activeRole'] as String,
      roles: List<String>.from(json['roles'] ?? const []),
      userType: json['userType'] as String,
    );
  }
  Session copyWith({String? jwt, String? refreshToken}) {
    return Session(
      jwt: jwt ?? this.jwt,
      // refreshToken: refreshToken ?? this.refreshToken,
      activeRole: activeRole,
      roles: roles,
      userType: userType,
    );
  }

  String get normalizedRole => activeRole.toLowerCase().replaceAll(' ', '_');
  bool get isSuperAdmin =>
      normalizedRole == 'super_admin' || normalizedRole == 'administrator';
}
