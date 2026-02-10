import 'package:kmb_app/core/auth/user_role.dart';

class RolePermissions {
  static bool isAdmin(UserRole role) => role == UserRole.superAdmin;

  static bool canViewPayments(UserRole role) => isAdmin(role);

  static bool canViewPermits(UserRole role) =>
      role == UserRole.superAdmin ||
      role == UserRole.dealing ||
      role == UserRole.executive ||
      role == UserRole.chairman;

  
  static String roleLabel(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Administrator';
      case UserRole.dealing:
        return 'Dealer';
      case UserRole.executive:
        return 'Executive';
      case UserRole.chairman:
        return 'Chairman';
    }
  }
}
