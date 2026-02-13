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

  Widget sectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  return Scaffold(
    backgroundColor: const Color(0xffF5F6FA),
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: const Text(
        'Application Details',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          /// ---------------- Application Info ----------------
          sectionCard(
            title: 'Application Information',
            children: [
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
              const SizedBox(height: 14),
              DetailsRow(
                left: DetailField(
                  label: 'APPLICATION STATUS',
                  value: statuUi.label,
                ),
                right: DetailField(
                  label: 'PERMIT STATUS',
                  value: permitStatus(applicationModel.permitIssued),
                ),
              ),
            ],
          ),

          /// ---------------- Owner Info ----------------
          sectionCard(
            title: 'Owner Information',
            children: [
              DetailsRow(
                left: DocumentImage(
                  category: DocCategory.owner,
                  type: DocType.passportPhoto,
                  id: applicationModel.id,
                ),
                right: DetailField(
                  label: 'OWNER NAME',
                  value: applicationModel.ownerName,
                ),
              ),
              const SizedBox(height: 14),
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
              const SizedBox(height: 14),
              DetailsRow(
                left: DetailField(
                  label: 'PAN',
                  value: owner['owner_pan'] ?? "Not available",
                  showViewIcon: true,
                  onView: () {},
                ),
                right: DetailField(
                  label: 'VOTER NO',
                  value: owner['owner_voter'],
                  showViewIcon: true,
                  onView: () {},
                ),
              ),
            ],
          ),

          /// ---------------- Driver Info ----------------
          sectionCard(
            title: 'Driver Information',
            children: [
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
            ],
          ),

          /// ---------------- Vehicle Info ----------------
          sectionCard(
            title: 'Vehicle Information',
            children: [
              DetailsRow(
                left: DetailField(
                  label: 'RC ISSUE DATE',
                  value: vehicle['rc_issue_date'] ?? "Not available",
                ),
                right: DetailField(
                  label: 'RC EXPIRY DATE',
                  value: vehicle['rc_expiry_date'] ?? "Not available",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// ---------------- Buttons ----------------
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          ApprovePermitDialog(application: applicationModel),
                    );
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff6A5AE0), Color(0xff8E7CFF)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'ACCEPT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (_) => Dialog());
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffE53935), Color(0xffFF6B6B)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'REJECT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}
}