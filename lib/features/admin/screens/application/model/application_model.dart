import 'package:kmb_app/features/admin/widgets/status_mapper.dart';

class ApplicationModel {
  final int id;
  final String applicationNo;

  final String ownerName;
  final String ownerPhone;
  final String ownerAadhar;

  final String driverName;
  final String driverPhone;
  final String driverAadhar;

  final String? vehicleRC;
  final DateTime? appliedOn;

  final Map<String, dynamic>? ownerDetails;
  final Map<String, dynamic>? driverDetails;
  final Map<String, dynamic>? vehicleDetails;

  final int status;
  final int statusCode;
  final int applicationStatus;
  final int permitIssued;
  final String? permitNo;
  // final String? permitIssueDate;
  // final String? permitExpiryDate;

  ApplicationModel({
    required this.id,
    required this.applicationNo,
    this.appliedOn,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerAadhar,

    required this.driverName,
    required this.driverPhone,
    required this.driverAadhar,

    required this.ownerDetails,
    required this.driverDetails,
    required this.vehicleDetails,
    this.vehicleRC,
    required this.applicationStatus,
    required this.status,
    required this.statusCode,
    required this.permitIssued,
    this.permitNo,
    // this.permitIssueDate,
    // this.permitExpiryDate,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    print(json);

    return ApplicationModel(
      id: json['id'] ?? 0,
      applicationNo: json['application_no']?.toString() ?? '',

      appliedOn: DateTime.tryParse(json['apply_date']?.toString() ?? ''),

      ownerName: json['owner_name']?.toString() ?? '',
      ownerPhone: json['owner_phone']?.toString() ?? '',
      ownerAadhar: json['owner_aadhar']?.toString() ?? '',

      driverName: json['driver_name']?.toString() ?? '',
      driverPhone: json['driver_phone']?.toString() ?? '',
      driverAadhar: json['driver_aadhar']?.toString() ?? '',

      ownerDetails: json['owner_details'],
      driverDetails: json['driver_details'],
      vehicleRC: json['vehicle_rc']?.toString() ?? '',
      vehicleDetails: json['vehicle_details'],

      // status: _normalizeStatus(json['current_status']?.toString()),
      status: mapStatusString(json['current_status'].toString()),
      statusCode: mapStatusString(json['current_status_no'].toString()),

      // applicationStatus: _toInt(json['status_no'].toString()),
      applicationStatus: mapStatusString(json['application_status']),

      // applicationStatus: _normalizeStatus(
      //   json['application_status']?.toString(),
      // ),
      permitIssued: int.tryParse(json['permit_issued']?.toString() ?? '0') ?? 0,

      permitNo: json['permit_no']?.toString(),
      // permitIssueDate: json['permit_issu_date'],
      // permitExpiryDate: json['permit_expiry_date'],
    );
  }




  

  // static String _normalizeStatus(dynamic raw) {
  //   try {
  //     final status = raw?.toString().toLowerCase().trim() ?? '';

  //     switch (status) {
  //       case 'approved':
  //       case 'chairman_approved':
  //         return StatusCode.chairmanApproved;

  //       case 'rejected':
  //       case 'chairman_rejected':
  //         return StatusCode.chairmanRejected;

  //       case 'eo_approved':
  //         return StatusCode.eoApproved;

  //       case 'eo_reject':
  //         return StatusCode.eoReject;

  //       case 'dealing_approved':
  //         return StatusCode.dealingApproved;

  //       case 'dealing_reject':
  //         return StatusCode.dealingReject;

  //       case 'submitted':
  //         return StatusCode.submitted;

  //       case 'not_completed':
  //         return StatusCode.notSubmitted;

  //       default:
  //         return StatusCode.unknown;
  //     }
  //   } catch (_) {
  //     return StatusCode.unknown;
  //   }
  // }
}

// int _toInt(dynamic value) {
//   if (value == null) return 0;
//   return int.tryParse(value.toString()) ?? 0;
// }


