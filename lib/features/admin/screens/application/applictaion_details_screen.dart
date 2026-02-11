import 'package:flutter/material.dart';
import 'package:kmb_app/core/utils/document_helper.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/widget/approve_dialog.dart';
import 'package:kmb_app/features/admin/widgets/detail_field.dart';
import 'package:kmb_app/features/admin/widgets/details_row.dart';
import 'package:kmb_app/features/admin/widgets/image_placeholder.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/shared/primary_button.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  final ApplicationModel applicationModel;

  const ApplicationDetailsScreen({super.key, required this.applicationModel});

  String permitStatus(int? v) {
    switch (v) {
      case 0:
        return "Pending";
      case 1:
        return "Issued";
      case 2:
        return "Rejected";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _build(context);
    } catch (e, s) {
      debugPrint('CRASH >>> $e');
      debugPrint('$s');
      rethrow;
    }
  }

  Widget _build(BuildContext context) {
    final statuUi = mapStatus(
      status: applicationModel.applicationStatus,
      type: StatusType.application,
    );

    final owner = applicationModel.ownerDetails ?? {};
    final driver = applicationModel.driverDetails ?? {};
    final vehicle = applicationModel.vehicleDetails ?? {};

    final ownerAddress = (owner['owner_address'] as Map?) ?? {};

    final driverAddress = (driver['driver_address'] as Map?) ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Application Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            DetailsRow(
              left: DetailField(
                label: 'APPLICATION NO',
                value: applicationModel.applicationNo,
              ),
              right: DetailField(
                label: 'APPLIED ON',
                value: applicationModel.appliedOn?.toString() ?? 'N/A',
              ),
            ),

            const SizedBox(height: 16),

            DetailsRow(
              left: DetailField(
                label: 'APPLICATION STATUS',
                value: statuUi.label,
              ),
              right: DetailField(
                label: 'PERMIT ISSUED',
                value: permitStatus(applicationModel.permitIssued),
              ),
            ),

            const SizedBox(height: 24),

            /// ---------------- Owner Info ----------------
            const Text(
              'Owner Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            DetailsRow(
              left: SizedBox(
                child: DocumentImage(
                  category: DocCategory.owner,
                  type: DocType.passportPhoto,
                  id: applicationModel.id,
                ),
              ),
              right: DetailField(
                label: 'OWNER NAME',
                value: applicationModel.ownerName,
              ),
            ),

            const SizedBox(height: 12),

            DetailsRow(
              left: DetailField(
                label: 'OWNER PHONE',
                value: applicationModel.ownerPhone,
              ),
              right: DetailField(
                label: 'AADHAAR',
                value: applicationModel.ownerAadhar,
                showViewIcon: true,
                onView: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: DocumentImage(
                        category: DocCategory.owner,
                        type: DocType.aadharCard,
                        id: applicationModel.id,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            DetailsRow(
              left: DetailField(
                label: 'PAN',
                value: owner['owner_pan'] ?? "Not available",
                showViewIcon: true,
                onView: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: DocumentImage(
                        category: DocCategory.owner,
                        type: DocType.panCard,
                        id: applicationModel.id,
                      ),
                    ),
                  );
                },
              ),
              right: DetailField(
                label: 'VOTER NO',
                value: owner['owner_voter'],
                showViewIcon: true,
                onView: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: DocumentImage(
                        category: DocCategory.owner,
                        type: DocType.voterId,
                        id: applicationModel.id,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            DetailField(
              label: 'ADDRESS',
              value:
                  [
                        ownerAddress['village'],
                        ownerAddress['post_office'],
                        ownerAddress['police_station'],
                        ownerAddress['ward_no'],
                        ownerAddress['district'],
                        ownerAddress['pin_code'],
                      ]
                      .where((e) => e != null && e.toString().trim().isNotEmpty)
                      .map((e) => e.toString())
                      .join(', '),
            ),

            const SizedBox(height: 24),

            /// ---------------- Driver Info ----------------
            const Text(
              'Driver Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DetailsRow(
              left: DocumentImage(
                category: DocCategory.driver,
                type: DocType.passportPhoto,
                id: applicationModel.id,
              ),
              right: DetailField(
                label: 'AUTHORIZATION LETTER',
                value: 'VIEW',
                showViewIcon: true,
                onView: () {},
              ),
            ),

            const SizedBox(height: 12),

            DetailsRow(
              left: DetailField(
                label: 'DRIVER NAME',
                value: applicationModel.driverName,
              ),
              right: DetailField(
                label: 'DRIVER PHONE',
                value: applicationModel.driverPhone,
              ),
            ),

            const SizedBox(height: 16),

            DetailsRow(
              left: DetailField(
                label: 'AADHAAR',
                value: applicationModel.driverAadhar,
                showViewIcon: true,
                onView: () {},
              ),
              right: DetailField(
                label: 'PAN',
                value: driver['driver_pan'] ?? "Not available",
                showViewIcon: true,
                onView: () {},
              ),
            ),

            const SizedBox(height: 16),

            DetailsRow(
              left: DetailField(
                label: 'DRIVER VOTER NO',
                value: driver['driver_voter'],
                showViewIcon: true,
                onView: () {},
              ),
              right: DetailField(
                label: 'DRIVER ADDRESS',
                value:
                    [
                          driverAddress['village'],
                          driverAddress['post_office'],
                          driverAddress['police_station'],
                          driverAddress['ward_no'],
                          driverAddress['district'],
                          driverAddress['pin_code'],
                        ]
                        .where(
                          (e) => e != null && e.toString().trim().isNotEmpty,
                        )
                        .map((e) => e.toString())
                        .join(', '),
              ),
            ),

            const SizedBox(height: 24),

            /// ---------------- Vehicle Info ----------------
            const Text(
              'Vehicle Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            DetailsRow(
              left: DetailField(
                showViewIcon: true,
                label: 'REGISTRATION NUMBER',
                value: 'VIEW',

                onView: () {},
              ),
              right: DetailField(
                label: 'RC ISSUE DATE',
                value: vehicle['rc_issue_date'] ?? "Not available",
              ),
            ),

            const SizedBox(height: 12),
            DetailsRow(
              left: DetailField(
                label: 'RC EXPIRY DATE',
                value: vehicle['rc_expiry_date'] ?? "Not available",
              ),
              right: DetailField(
                label: 'INSURANCE NO',
                value: vehicle['rc_issue_date'] ?? "Not available",
              ),
            ),
            const SizedBox(height: 12),
            DetailsRow(
              left: DetailField(
                label: 'INSURANCE ISSUE DATE',
                value: vehicle['rc_expiry_date'] ?? "Not available",
              ),
              right: DetailField(
                label: 'INSURANCE EXPIRY DATE',
                value: vehicle['rc_issue_date'] ?? "Not available",
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PAYMENT INFORMATION',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DetailsRow(
              left: DetailField(label: 'TRANSACTION NO', value: ''),
              right: DetailField(label: 'TRANSACTION DATE', value: 'VIEW'),
            ),

            const SizedBox(height: 12),

            DetailsRow(
              left: DetailField(
                label: 'PAYMNET STATUS',
                value: applicationModel.driverName,
              ),
              right: DetailField(
                label: 'AMOUNT PAID',
                value: applicationModel.driverPhone,
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'ACCEPT',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            ApprovePermitDialog(application: applicationModel),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    text: 'REJECT',
                    onPressed: () {
                      showDialog(context: context, builder: (_) => Dialog());
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
