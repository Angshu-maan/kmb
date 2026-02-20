import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';
import 'package:kmb_app/features/admin/widgets/status_ui.dart';
import '../model/application_model.dart';

class ApplicationRow extends StatelessWidget {
  final ApplicationModel kmbApplication;

  const ApplicationRow({super.key, required this.kmbApplication});

  @override
  Widget build(BuildContext context) {
    final statusUi = _resolveStatusUi();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Application Number + Status (Left Side)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kmbApplication.applicationNo,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                            color: Colors.grey.shade600, // Always grey
                          ),
                        ),
                        TextSpan(
                          text: statusUi.label,
                          style: TextStyle(
                            color: statusUi.color, // Your dynamic color logic
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// View Button (Right Side)
            ElevatedButton(
              onPressed: () => _navigateToDetails(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5ACD), // purple
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("View"),
            ),
          ],
        ),
      ),
    );
  }

  StatusUi _resolveStatusUi() {
    final currentStatus = kmbApplication.currentStatus;

    StatusUi statusUi;

    if (kmbApplication.permitIssued == 1) {
      statusUi = mapStatus(
        status: StatusCode.permitIssued,
        type: StatusType.application,
      );
    } else {
      statusUi = mapStatus(status: currentStatus, type: StatusType.application);
    }

    /// Override ONLY these two statuses
    if (currentStatus == StatusCode.submitted) {
      return StatusUi(
        statusUi.label,
        Colors.green, // Submitted color
      );
    }

    if (currentStatus == StatusCode.dealingApproved) {
      return StatusUi(
        statusUi.label,
        Colors.blue.shade700, // Dealing Approved color
      );
    }
    if (currentStatus == StatusCode.executiveApproved) {
      return StatusUi(
        statusUi.label,
        Colors.yellow, // Dealing Approved color
      );
    }
    if (currentStatus == StatusCode.chairmanApproved) {
      return StatusUi(
        statusUi.label,
        const Color.fromARGB(255, 240, 54, 247), // Dealing Approved color
      );
    }
    if (currentStatus == StatusCode.sentToDealingForIssue) {
      return StatusUi(
        statusUi.label,
        Colors.blueGrey, // Dealing Approved color
      );
    }

    return statusUi;
  }

  void _navigateToDetails(BuildContext context) {
    context.pushNamed('application_details', extra: kmbApplication);
  }
}
