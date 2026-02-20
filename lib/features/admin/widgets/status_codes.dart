enum StatusType { application, activeInactive }

class StatusCode {
  static const int inactive = 0;
  static const int active = 1;

  static const int notCompleted = 0;
  static const int submitted = 1;

  static const int dealingRejected = 2;
  static const int dealingApproved = 3;

  static const int executiveRejected = 4;
  static const int executiveApproved = 5;

  static const int chairmanRejected = 6;
  static const int chairmanApproved = 7;

  static const int sentToDealingForIssue = 8;
  static const int permitIssued = 9;

  static bool isRejected(int status) {
    return status == dealingRejected ||
        status == executiveRejected ||
        status == chairmanRejected;
  }

  static bool isFinalApproval(int status) {
    return status == chairmanApproved;
  }

  static bool canExecutiveIssue(int status) {
    return status == chairmanApproved;
  }

  static bool canDealingIssue(int status) {
    return status == sentToDealingForIssue;
  }

  static bool isCompleted(int status) {
    return status == permitIssued;
  }

  static bool isInProgress(int status) {
    return status == submitted ||
        status == dealingApproved ||
        status == executiveApproved ||
        status == chairmanApproved ||
        status == sentToDealingForIssue;
  }
}
