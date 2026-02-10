import 'owner_address_model.dart';

class OwnerModel {
  final int id;
  final int? applicationId;
  final String? ownerName;
  final String ownerPhone;
  final OwnerAddress? ownerAddress;
  final String? ownerPan;
  final String? ownerAadhar;
  final String? ownerVoter;
  final String? guardianName;
  final bool phoneVerified;
  final bool active;
  final DateTime createdAt;
  final String documentsFolder;

  OwnerModel({
    required this.id,
    this.applicationId,
    this.ownerName,
    required this.ownerPhone,
    this.ownerAddress,
    this.ownerPan,
    this.ownerAadhar,
    this.ownerVoter,
    this.guardianName,
    required this.phoneVerified,
    required this.active,
    required this.createdAt,
    required this.documentsFolder,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'],
      applicationId: json['application_id'],
      ownerName: json['owner_name'],
      ownerPhone: json['owner_phone'] ?? '',
      ownerAddress: json['owner_address'] != null &&
              json['owner_address'] is Map
          ? OwnerAddress.fromJson(
              Map<String, dynamic>.from(json['owner_address']),
            )
          : null,
      ownerPan: json['owner_pan'],
      ownerAadhar: json['owner_aadhar'],
      ownerVoter: json['owner_voter'],
      guardianName: json['guardian_name'],
      phoneVerified: json['owner_phone_verified'] == 1,
      active: json['active'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      documentsFolder: json['documents_folder'] ?? '',
    );
  }
}
