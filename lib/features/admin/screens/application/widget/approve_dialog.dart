import 'package:flutter/material.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/core/network/approve_permit_api.dart';

class ApprovePermitDialog extends StatefulWidget {
  final ApplicationModel application;

  const ApprovePermitDialog({super.key, required this.application});

  @override
  State<ApprovePermitDialog> createState() => _ApprovePermitDialogState();
}

class _ApprovePermitDialogState extends State<ApprovePermitDialog> {
  bool loading = false;

  Future<void> approvePermit() async {
    setState(() => loading = true);

    try {
      final res = await PermitService.approvePermit(
        applicationRef: widget.application.id,
        permitNumber: '',
        expiryDate: '',
        token: '',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res['message'])));

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Approve Permit",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Confirm that you want to approve this permit application",
                ),
              ),

              const SizedBox(height: 20),

              Text("Application No: ${widget.application.applicationNo}"),
              Text("Owner: ${widget.application.ownerName}"),
              Text("Driver: ${widget.application.driverName}"),
              Text("Vehicle: ${widget.application.vehicleRC}"),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: loading ? null : approvePermit,
                    child: loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
