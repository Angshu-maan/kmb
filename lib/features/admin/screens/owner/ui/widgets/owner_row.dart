import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';
import '../../model/owner_model.dart';

class OwnerRow extends StatelessWidget {
  final OwnerModel owner;

  const OwnerRow({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isInactive = owner.active == StatusCode.inactive;

    final statusUi = mapStatus(
      status: owner.active,
      type: StatusType.activeInactive,
    );

    final String displayName = isInactive ? "Not available" : owner.ownerName;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isInactive ? Colors.grey : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: "Status: ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: statusUi.label,
                        style: TextStyle(
                          color: statusUi.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT SIDE
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.pushNamed('owner_details', extra: owner);
            },
            child: const Text("View", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
