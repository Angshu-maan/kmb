// import 'driver_address_model.dart';

// class DriverModel {
//   final int id;
//   final int applicationId;
//   final int ownerId;
//   final int vehicleId;
//   final String driverName;
//   final String? driverContact;
//   final DriverAddress? driverAddress;
//   final String? driverPan;
//   final String? driverLicenseNo;
//   final DateTime? driverDlExpiryDate;
//   final String? driverAadhar;
//   final String? driverVoter;
//   final bool driverPhoneVerified;
//   final String? authCtNo;
//   final DateTime? authCtIssueDate;
//   final DateTime? authCtExpiryDate;
//   final bool active;
//   final String? documentsFolder;
//   final DateTime? createdAt;

//   DriverModel({
//     required this.id,
//     required this.applicationId,
//     required this.ownerId,
//     required this.vehicleId,
//     required this.driverName,
//     required this.driverContact,
//     required this.driverAddress,
//     this.driverPan,
//     required this.driverLicenseNo,
//     required this.driverDlExpiryDate,
//     this.driverAadhar,
//     this.driverVoter,
//     required this.driverPhoneVerified,
//     this.authCtNo,
//     this.authCtIssueDate,
//     this.authCtExpiryDate,
//     required this.active,
//     required this.documentsFolder,
//     required this.createdAt,
//   });

//   factory DriverModel.fromJson(Map<String, dynamic> json) {
//     return DriverModel(
//       id: json['id'],
//       applicationId: json['application_id'],
//       ownerId: json['owner_id'],
//       vehicleId: json['vehicle_id'],
//       driverName: json['driver_name'],
//       driverContact: json['driver_contact'],
//       // driverAddress: DriverAddress.fromJson(json['driver_address']),
//       driverAddress: (json['driver_address'] is Map<String, dynamic>)
//           ? DriverAddress.fromJson(json['driver_address'])
//           : null,

//       driverPan: json['driver_pan'],
//       driverLicenseNo: json['driver_license_no'],
//       driverDlExpiryDate: DateTime.parse(json['driver_dl_expiry_date']),
//       driverAadhar: json['driver_aadhar'],
//       driverVoter: json['driver_voter'],
//       driverPhoneVerified: json['driver_phone_verified'] == 1,
//       authCtNo: json['auth_ct_no'],
//       authCtIssueDate: json['auth_ct_issue_date'] != null
//           ? DateTime.parse(json['auth_ct_issue_date'])
//           : null,
//       authCtExpiryDate: json['auth_ct_expiry_date'] != null
//           ? DateTime.parse(json['auth_ct_expiry_date'])
//           : null,
//       active: json['active'] == 1,
//       documentsFolder: json['documents_folder'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }

//   // Map<String, dynamic> toJson() {
//   //   return {
//   //     'id': id,
//   //     'application_id': applicationId,
//   //     'owner_id': ownerId,
//   //     'vehicle_id': vehicleId,
//   //     'driver_name': driverName,
//   //     'driver_contact': driverContact,
//   //     'driver_address': driverAddress.toJson(),
//   //     'driver_pan': driverPan,
//   //     'driver_license_no': driverLicenseNo,
//   //     'driver_dl_expiry_date': driverDlExpiryDate
//   //         .toIso8601String()
//   //         .split('T')
//   //         .first,
//   //     'driver_aadhar': driverAadhar,
//   //     'driver_voter': driverVoter,
//   //     'driver_phone_verified': driverPhoneVerified ? 1 : 0,
//   //     'auth_ct_no': authCtNo,
//   //     'auth_ct_issue_date': authCtIssueDate?.toIso8601String(),
//   //     'auth_ct_expiry_date': authCtExpiryDate?.toIso8601String(),
//   //     'active': active ? 1 : 0,
//   //     'documents_folder': documentsFolder,
//   //     'created_at': createdAt.toIso8601String(),
//   //   };
//   // }
// }

import 'dart:io';

import 'driver_address_model.dart';

class DriverModel {
  final int id;
  final int applicationId;
  final int ownerId;
  final int vehicleId;

  final String driverName;
  final String? driverContact;

  final DriverAddress? driverAddress;

  final String? driverPan;
  final String? driverLicenseNo;
  final DateTime? driverDlExpiryDate;

  final String? driverAadhar;
  final String? driverVoter;

  final bool driverPhoneVerified;

  final String? authCtNo;
  final DateTime? authCtIssueDate;
  final DateTime? authCtExpiryDate;

  final int active;
  final String? documentsFolder;
  final DateTime? createdAt;
  final File? file;

  const DriverModel({
    required this.id,
    required this.applicationId,
    required this.ownerId,
    required this.vehicleId,
    required this.driverName,
    this.driverContact,
    this.driverAddress,
    this.driverPan,
    this.driverLicenseNo,
    this.driverDlExpiryDate,
    this.driverAadhar,
    this.driverVoter,
    required this.driverPhoneVerified,
    this.authCtNo,
    this.authCtIssueDate,
    this.authCtExpiryDate,
    required this.active,
    this.documentsFolder,
    this.createdAt,
    this.file,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? 0,
      applicationId: json['application_id'] ?? 0,
      ownerId: json['owner_id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,

      driverName: json['driver_name'] ?? '',

      driverContact: json['driver_contact'],

      driverAddress: json['driver_address'] is Map<String, dynamic>
          ? DriverAddress.fromJson(json['driver_address'])
          : null,

      driverPan: json['driver_pan'],
      driverLicenseNo: json['driver_license_no'],

      driverDlExpiryDate:
          json['driver_dl_expiry_date'] != null &&
              json['driver_dl_expiry_date'].toString().isNotEmpty
          ? DateTime.tryParse(json['driver_dl_expiry_date'])
          : null,

      driverAadhar: json['driver_aadhar'],
      driverVoter: json['driver_voter'],

      driverPhoneVerified: json['driver_phone_verified'] == 1,

      authCtNo: json['auth_ct_no'],
      authCtIssueDate: json['auth_ct_issue_date'] != null
          ? DateTime.tryParse(json['auth_ct_issue_date'])
          : null,
      authCtExpiryDate: json['auth_ct_expiry_date'] != null
          ? DateTime.tryParse(json['auth_ct_expiry_date'])
          : null,

      active: json['active'],
      documentsFolder: json['documents_folder'],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      file: json[''],
    );
  }

  // ---------- SAFE PARSERS ----------

  // static int _toInt(dynamic value) {
  //   if (value == null) return 0;
  //   return int.tryParse(value.toString()) ?? 0;
  //   }

  // static DateTime? _toDate(dynamic value) {
  //   if (value == null || value.toString().isEmpty) return null;
  //   return DateTime.tryParse(value.toString());
  // }
}
