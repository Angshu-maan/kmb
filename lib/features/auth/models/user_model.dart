import 'package:kmb_app/core/auth/user_role.dart';


class AppUser {
  final String id;
  final String name;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.role,
  });
}
