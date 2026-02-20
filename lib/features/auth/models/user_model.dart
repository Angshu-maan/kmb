import 'package:kmb_app/core/auth/user_role.dart';

class UserModel {
  final int id;
  final String name;
  final String phone;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
  });

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: int.parse(json['id'].toString()),
  //     name: json['name'] ?? '',
  //     role: json['user_roles'] ?? '',
  //     phone: json['phone_no'],
  //   );
  // }
}
