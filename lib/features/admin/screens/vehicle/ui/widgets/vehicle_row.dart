import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../model/vehicle_model.dart';

class VehicleRow extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleRow({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Name
          Expanded( child: _Cell(vehicle.rcNo ??'Not Available')),

          // Status
          // Expanded(
          //   child: Column(
          //     children: [
          //       Center(child: StatusBadge(active: vehicle.active)),
          //       Text(vehicle.active.toString())
          //     ],
          //   ),
          // ),

          // Actions
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.visibility),
                tooltip: 'View Vehicle',
                onPressed: () {
                  context.pushNamed('vehicle_details', extra: vehicle);
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
