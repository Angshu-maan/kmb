
enum UserRole {
  superAdmin,
  chairman,
  executive,
  dealing,
}

extension UserRoleX on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Administrator';
      case UserRole.chairman:
        return 'Chairman';
      case UserRole.executive:
        return 'Executive';
      case UserRole.dealing:
        return 'Dealer';
    }
  }
}

UserRole mapRole(String role) {
  switch (role) {
    case 'administrator':
      return UserRole.superAdmin;
    case 'chairman':
      return UserRole.chairman;
    case 'executive_officer':
      return UserRole.executive;
    case 'dealings':
      return UserRole.dealing;
    default:
      throw Exception('Unknown role: $role');
  }
}
