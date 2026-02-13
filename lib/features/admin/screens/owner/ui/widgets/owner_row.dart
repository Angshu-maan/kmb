import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';
import '../../model/owner_model.dart';
import '../../../../widgets/status_badge.dart';

class OwnerRow extends StatelessWidget {
  final OwnerModel owner;

  const OwnerRow({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final statusUi = mapStatus(
      status: owner.active,
      type: StatusType.activeInactive,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent, // important for theme
      child: Row(
        children: [
          /// ================= NAME =================
          Expanded(flex: 2, child: _Cell(owner.ownerName)),

          /// ================= PHONE =================
          Expanded(flex: 2, child: _Cell(owner.ownerPhone)),

          /// ================= STATUS =================
          Expanded(
            child: Center(
              child: StatusBadge(
                label: statusUi.label,
                color: statusUi.color,
                display: StatusDisplay.dotOnly,
              ),
            ),
          ),

          /// ================= ACTION =================
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: colors.onSurface, 
                ),
                tooltip: 'View Owner',
                onPressed: () {
                  context.pushNamed('owner_details', extra: owner);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// THEME SAFE TABLE CELL
/// ===============================
class _Cell extends StatelessWidget {
  final String text;

  const _Cell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 14),
    );
  }
}
