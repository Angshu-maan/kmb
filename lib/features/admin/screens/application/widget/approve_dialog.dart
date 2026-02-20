import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmb_app/core/auth/auth_session_helper.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/core/network/approve_permit_api.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ApprovePermitDialog extends StatefulWidget {
  final ApplicationModel application;
  final bool isReject;

  const ApprovePermitDialog({
    super.key,
    required this.application,
    this.isReject = false,
  });

  @override
  State<ApprovePermitDialog> createState() => _ApprovePermitDialogState();
}

class _ApprovePermitDialogState extends State<ApprovePermitDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _permitController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _rejectReasonController = TextEditingController();

  bool loading = false;
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      selectedDate = date;
      _expiryController.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final token = await AuthSessionHelper.getAuthToken();
      final role = context.read<AuthProvider>().role;

      Map<String, dynamic> res;

      /// ================= DEALING APPROVE =================
      if (role?.name == "dealing" && !widget.isReject) {
        res = await PermitService.permitIssuednReject(
          applicationRef: widget.application.id,
          permitNo: _permitController.text.trim(),
          userRef: widget.application.id,
          permitExpiryDate: selectedDate!.toIso8601String(),
          token: token,
        );
      }
      /// ================= EO / CHAIRMAN =================
      else {
        res = await PermitService.approveNreject(
          applicationRef: widget.application.id,
          summary: widget.isReject ? _rejectReasonController.text.trim() : null,
          token: token,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res['message'] ?? "Success")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _permitController.dispose();
    _expiryController.dispose();
    _rejectReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthProvider>().role;
    final isDealing = role?.name == "dealing";

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isReject
                      ? "Reject Application"
                      : "Approve Application",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.isReject
                        ? "Provide rejection reason"
                        : "Confirm approval details",
                  ),
                ),

                const SizedBox(height: 20),

                Text("Application No: ${widget.application.applicationNo}"),
                Text("Owner: ${widget.application.ownerName}"),
                Text("Driver: ${widget.application.driverName}"),
                Text("Vehicle: ${widget.application.vehicleRC}"),

                const SizedBox(height: 20),

                /// ================= DEALING INPUT =================
                if (!widget.isReject && isDealing) ...[
                  TextFormField(
                    controller: _permitController,
                    decoration: const InputDecoration(
                      labelText: "Permit Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? "Permit number required"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _expiryController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      labelText: "Permit Expiry Date",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? "Expiry date required"
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],

                /// ================= REJECT INPUT =================
                if (widget.isReject) ...[
                  TextFormField(
                    controller: _rejectReasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Rejection Reason",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? "Reason required"
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: loading ? null : () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.isReject ? "Reject" : "Confirm"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
