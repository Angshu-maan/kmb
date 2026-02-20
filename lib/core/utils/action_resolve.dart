import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';

List<ApplicationAction> getAvailableActions({
  required UserRole role,
  required int status,
  required int permitIssued,
}) {
  final actions = <ApplicationAction>[];

  switch (role) {
    case UserRole.dealing:
      if (status == StatusCode.submitted) {
        actions.addAll([ApplicationAction.accept, ApplicationAction.reject]);
      }

      if (status == StatusCode.dealingApproved) {
        actions.add(ApplicationAction.revert);
      }
      break;

    case UserRole.executive:
      if (status == StatusCode.dealingApproved) {
        actions.addAll([ApplicationAction.accept, ApplicationAction.reject]);
      }

      if (status == StatusCode.permitIssued && permitIssued == 1) {
        actions.add(ApplicationAction.revert);
      }
      break;

    case UserRole.chairman:
      if (status == StatusCode.executiveApproved) {
        actions.addAll([ApplicationAction.accept, ApplicationAction.reject]);
      }

      if (status == StatusCode.permitIssued ||
          status == StatusCode.chairmanApproved ||
          status == StatusCode.executiveApproved ||
          status == StatusCode.dealingApproved) {
        actions.add(ApplicationAction.revert);
      }
      break;

    case UserRole.superAdmin:
      actions.addAll([
        ApplicationAction.accept,
        ApplicationAction.reject,
        ApplicationAction.revert,
      ]);
      break;
  }

  return actions;
}
