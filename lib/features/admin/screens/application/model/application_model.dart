import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';

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

  final int applicationStatus;

  final int currentStatus;

  final int permitIssued;
  final String? permitNo;

  final String transactionNo;
  final DateTime? transactionDate;
  final String transactionStatus;
  final String amount;

  const ApplicationModel({
    required this.id,
    required this.applicationNo,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerAadhar,
    required this.driverName,
    required this.driverPhone,
    required this.driverAadhar,
    required this.applicationStatus,
    required this.currentStatus,
    required this.permitIssued,
    this.vehicleRC,
    this.appliedOn,
    this.ownerDetails,
    this.driverDetails,
    this.vehicleDetails,
    this.permitNo,

    required this.transactionNo,
    required this.transactionDate,
    required this.transactionStatus,
    required this.amount,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      applicationNo: json['application_no']?.toString() ?? '',

      appliedOn: DateTime.tryParse(json['apply_date']?.toString() ?? ''),

      ownerName: json['owner_name']?.toString() ?? '',
      ownerPhone: json['owner_phone']?.toString() ?? '',
      ownerAadhar: json['owner_aadhar']?.toString() ?? '',

      driverName: json['driver_name']?.toString() ?? '',
      driverPhone: json['driver_phone']?.toString() ?? '',
      driverAadhar: json['driver_aadhar']?.toString() ?? '',

      ownerDetails: json['owner_details'] is Map<String, dynamic>
          ? json['owner_details']
          : null,

      driverDetails: json['driver_details'] is Map<String, dynamic>
          ? json['driver_details']
          : null,

      vehicleRC: json['vehicle_rc']?.toString(),

      vehicleDetails: json['vehicle_details'] is Map<String, dynamic>
          ? json['vehicle_details']
          : null,

      /// Always map from current_status for list display
      // currentStatus: mapStatusString(json['current_status']?.toString() ?? ''),
      currentStatus:
          int.tryParse(json['current_status_no']?.toString() ?? '') ?? 0,

      /// Application status for detail screen
      applicationStatus: mapStatusString(
        json['application_status']?.toString() ?? '',
      ),

      permitIssued: int.tryParse(json['permit_issued']?.toString() ?? '0') ?? 0,

      permitNo: json['permit_no']?.toString(),

      transactionNo: json['transaction_no']?.toString() ?? '',
      transactionDate: DateTime.tryParse(
        json['payment_date']?.toString() ?? '',
      ),
      transactionStatus: json['payment_status']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
    );
  }
  bool get isPermitIssued => permitIssued == 1;
  get name => null;
}

extension ApplicationFilterX on ApplicationModel {
  bool matchesFilter(ApplicationFilter filter) {
    const approvedStatuses = {
      StatusCode.dealingApproved,
      StatusCode.executiveApproved,
      StatusCode.chairmanApproved,
      StatusCode.sentToDealingForIssue,
      StatusCode.permitIssued,
    };

    const rejectedStatuses = {
      StatusCode.dealingRejected,
      StatusCode.executiveRejected,
      StatusCode.chairmanRejected,
    };

    switch (filter) {
      case ApplicationFilter.issued:
        return currentStatus == StatusCode.permitIssued;

      case ApplicationFilter.approved:
        return currentStatus != StatusCode.permitIssued &&
            approvedStatuses.contains(currentStatus);

      case ApplicationFilter.rejected:
        return rejectedStatuses.contains(currentStatus);

      case ApplicationFilter.newApp:
        return currentStatus == StatusCode.submitted;
    }
  }
}

extension ApplicationWorkflowX on ApplicationModel {
  /// Visibility
  bool isVisibleForRole(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return true;

      case UserRole.dealing:
        return currentStatus == StatusCode.submitted ||
            currentStatus == StatusCode.sentToDealingForIssue;

      case UserRole.executive:
        return currentStatus == StatusCode.dealingApproved ||
            currentStatus == StatusCode.chairmanApproved;

      case UserRole.chairman:
        return currentStatus == StatusCode.executiveApproved;
    }
  }

  /// Approve
  bool canApprove(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return currentStatus != StatusCode.permitIssued &&
            !StatusCode.isRejected(currentStatus);

      case UserRole.dealing:
        return currentStatus == StatusCode.submitted;

      case UserRole.executive:
        return currentStatus == StatusCode.dealingApproved;

      case UserRole.chairman:
        return currentStatus == StatusCode.executiveApproved;
    }
  }

  /// Reject
  bool canReject(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return currentStatus != StatusCode.permitIssued &&
            !StatusCode.isRejected(currentStatus);

      case UserRole.dealing:
        return currentStatus == StatusCode.submitted;

      case UserRole.executive:
        return currentStatus == StatusCode.dealingApproved;

      case UserRole.chairman:
        return currentStatus == StatusCode.executiveApproved;
    }
  }

  /// Executive final issue
  bool canExecutiveIssue(UserRole role) {
    return (role == UserRole.executive || role == UserRole.superAdmin) &&
        currentStatus == StatusCode.chairmanApproved;
  }

  /// Executive send to dealing for issue
  bool canSendToDealing(UserRole role) {
    return (role == UserRole.executive || role == UserRole.superAdmin) &&
        currentStatus == StatusCode.chairmanApproved;
  }

  /// Dealing final issue
  bool canDealingIssue(UserRole role) {
    return (role == UserRole.dealing || role == UserRole.superAdmin) &&
        currentStatus == StatusCode.sentToDealingForIssue;
  }

  /// Revert Logic
  bool canRevert(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return currentStatus != StatusCode.permitIssued &&
            currentStatus != StatusCode.submitted;

      case UserRole.chairman:
        return currentStatus == StatusCode.chairmanApproved;

      case UserRole.executive:
        return currentStatus == StatusCode.executiveApproved ||
            currentStatus == StatusCode.chairmanApproved;

      case UserRole.dealing:
        return currentStatus == StatusCode.dealingApproved;
    }
  }

  /// Revert Target
  int? revertTo() {
    switch (currentStatus) {
      case StatusCode.chairmanApproved:
        return StatusCode.executiveApproved;

      case StatusCode.executiveApproved:
        return StatusCode.dealingApproved;

      case StatusCode.dealingApproved:
        return StatusCode.submitted;

      case StatusCode.sentToDealingForIssue:
        return StatusCode.chairmanApproved;

      default:
        return null;
    }
  }
}
