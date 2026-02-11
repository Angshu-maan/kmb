enum StatusType { application, activeInactive }

class StatusCode {
  // Common
  static const int inactive = 0;
  static const int active = 1;

  static const int submitted = 1;
  static const int notSubmitted = 0;

  static const int dealingApproved = 3;
  static const int dealingReject = 2;

  static const int eoApproved = 5;
  static const int eoReject = 4;

  static const int chairmanApproved = 7;
  static const int chairmanRejected = 6;

  // String --

  // static const String submitted = 'Sumbitted';
  // static const String notSubmitted = 'Not Submitted';

  // static const String approved = 'Approved';
  // static const String rejected = 'Rejected';

  // static const String dealingApproved = 'Approved by Dealing';
  // static const String dealingReject = 'Rejected by Dealing';

  // static const String eoApproved = 'Approved by EO';
  // static const String eoReject = 'Rejected by EO';

  // static const String chairmanApproved = 'Approved by Chairman';
  // static const String chairmanRejected = 'Rejected by Chairman';

  // static const String unknown = 'Unknown';
}
