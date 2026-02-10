import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../model/owner_model.dart';
import '../../../../widgets/status_badge.dart';

class OwnerRow extends StatelessWidget {
  final OwnerModel owner;

  const OwnerRow({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Name
          Expanded(flex: 2, child: _Cell(owner.ownerName ?? 'Not Available')),

          // Phone
          Expanded(flex: 2, child: _Cell(owner.ownerPhone)),

          // Status
          Expanded(
            child: Center(child: StatusBadge(active: owner.active)),
          ),

          // Actions
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.visibility),
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
/// Table Cell (SAFE & REUSABLE)
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
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    );
  }
}
