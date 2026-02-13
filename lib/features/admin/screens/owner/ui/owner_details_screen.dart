import 'package:flutter/material.dart';
import 'package:kmb_app/core/utils/document_helper.dart';
import 'package:kmb_app/features/admin/screens/owner/model/owner_model.dart';
import 'package:kmb_app/features/admin/widgets/image_placeholder.dart';

class OwnerDetailsScreen extends StatelessWidget {
  final OwnerModel owner;

  const OwnerDetailsScreen({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Owner Details"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ================= OWNER INFORMATION CARD =================
            _buildSectionCard(
              context: context,
              icon: Icons.person_outline,
              title: "Owner Information",
              child: Column(
                children: [

                  /// Passport Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: DocumentImage(
                        category: DocCategory.owner,
                        type: DocType.passportPhoto,
                        id: owner.id,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildField(
                    context,
                    "Owner Name",
                    owner.ownerName.isNotEmpty
                        ? owner.ownerName
                        : "Not available",
                  ),

                  _buildField(
                    context,
                    "Owner Phone",
                    owner.ownerPhone.isNotEmpty
                        ? owner.ownerPhone
                        : "Not available",
                  ),

                  _buildField(
                    context,
                    "Aadhaar",
                    owner.ownerAadhar?.isNotEmpty == true
                        ? owner.ownerAadhar!
                        : "Not available",
                    showView: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: DocumentImage(
                            category: DocCategory.owner,
                            type: DocType.aadharCard,
                            id: owner.id,
                          ),
                        ),
                      );
                    },
                  ),

                  _buildField(
                    context,
                    "PAN",
                    owner.ownerPan?.isNotEmpty == true
                        ? owner.ownerPan!
                        : "Not available",
                    showView: true,
                    onTap: () {},
                  ),

                  _buildField(
                    context,
                    "Voter ID",
                    owner.ownerVoter?.isNotEmpty == true
                        ? owner.ownerVoter!
                        : "Not available",
                    showView: true,
                    onTap: () {},
                  ),

                  _buildField(
                    context,
                    "Address",
                    owner.ownerAddress?.formatted ?? "Not available",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= Modern Section Card =================
  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : colors.primaryContainer.withOpacity(0.25),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Header Row
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  /// ================= Modern Field =================
  Widget _buildField(
    BuildContext context,
    String label,
    String? value, {
    bool showView = false,
    VoidCallback? onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.5,
                    color: colors.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? "N/A",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          if (showView)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: colors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
