import 'package:flutter/material.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_ui.dart';

StatusUi mapStatus({required int status, required StatusType type}) {
  switch (type) {
    case StatusType.activeInactive:
      return status == StatusCode.active
          ? const StatusUi('Active', Colors.green)
          : const StatusUi('Inactive', Colors.red);

    case StatusType.application:
      switch (status) {
        case StatusCode.notCompleted:
          return const StatusUi('Not Submitted', Colors.grey);

        case StatusCode.submitted:
          return const StatusUi('Submitted', Colors.grey);

        case StatusCode.dealingApproved:
          return const StatusUi('Dealing Approved', Colors.orange);

        case StatusCode.dealingRejected:
          return const StatusUi('Dealing Rejected', Colors.red);

        case StatusCode.executiveApproved:
          return const StatusUi('Executive Approved', Colors.blue);

        case StatusCode.executiveRejected:
          return const StatusUi('Executive Rejected', Colors.red);

        case StatusCode.chairmanApproved:
          return const StatusUi('Chairman Approved', Colors.green);

        case StatusCode.chairmanRejected:
          return const StatusUi('Chairman Rejected', Colors.red);

        case StatusCode.sentToDealingForIssue:
          return const StatusUi('Sent to Dealing for Issue', Colors.purple);

        case StatusCode.permitIssued:
          return const StatusUi('Permit Issued', Colors.green);

        default:
          return const StatusUi('Unknown', Colors.grey);
      }
  }
}

mapStatusString(String? status) {
  switch (status?.toLowerCase().trim()) {
    case 'submitted':
      return StatusCode.submitted;

    case 'dealing_approved':
      return StatusCode.dealingApproved;

    case 'dealing_rejected':
      return StatusCode.dealingRejected;

    case 'eo_approved':
      return StatusCode.executiveApproved;

    case 'eo_rejected':
      return StatusCode.executiveRejected;

    case 'chairman_approved':
      return StatusCode.chairmanApproved;

    case 'chairman_rejected':
      return StatusCode.chairmanRejected;

    case 'sent_to_dealing_for_issue':
      return StatusCode.sentToDealingForIssue;

    case 'permit_issued':
      return StatusCode.permitIssued;

    default:
      return StatusCode.notCompleted;
  }
}
