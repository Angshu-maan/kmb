import 'package:flutter/material.dart';
import 'status_codes.dart';
import 'status_ui.dart';

StatusUi mapStatus({required int status, required StatusType type}) {
  switch (type) {
    case StatusType.activeInactive:
      return status == StatusCode.active
          ? const StatusUi('Active', Colors.green)
          : const StatusUi('Inactive', Colors.red);

    case StatusType.application:
      switch (status) {
        case StatusCode.submitted:
          return const StatusUi('Submitted', Colors.grey);

        case StatusCode.notSubmitted:
          return const StatusUi('Not Submitted', Colors.grey);

        case StatusCode.dealingApproved:
          return const StatusUi('Dealing Approved', Colors.orange);

        case StatusCode.dealingReject:
          return const StatusUi('Dealing Rejected', Colors.orange);

        case StatusCode.eoApproved:
          return const StatusUi('EO Approved', Colors.blue);

        case StatusCode.eoReject:
          return const StatusUi('EO Rejected', Colors.blue);

        case StatusCode.chairmanApproved:
          return const StatusUi('Chairman Approved', Colors.green);

        case StatusCode.chairmanRejected:
          return const StatusUi('Chairman Rejected', Colors.red);

        default:
          return const StatusUi('Unknown', Colors.grey);
      }
  }
}

mapStatusString(String? status) {
  switch (status?.toLowerCase().trim()) {
    case 'submitted':
      return StatusCode.submitted;

    case 'dealing appro':
    case 'dealing approved':
      return StatusCode.dealingApproved;

    case 'dealing reject':
    case 'dealing rejected':
      return StatusCode.dealingReject;

    case 'eo appro':
    case 'eo approved':
      return StatusCode.eoApproved;

    case 'eo reject':
    case 'eo rejected':
      return StatusCode.eoReject;

    case 'chairman appro':
    case 'chairman approved':
      return StatusCode.chairmanApproved;

    case 'chairman reject':
    case 'chairman rejected':
      return StatusCode.chairmanRejected;

    default:
      return StatusCode.submitted;
  }
}
