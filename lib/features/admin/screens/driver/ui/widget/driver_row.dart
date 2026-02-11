import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';
import '../../model/driver_model.dart';
import '../../../../widgets/status_badge.dart';

class DriverRow extends StatelessWidget {
  final DriverModel driver;

  const DriverRow({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final statusUi = mapStatus(
      status: driver.active,
      type: StatusType.activeInactive,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Name
          Expanded(
            flex: 2,
            child: _Cell(
              driver.driverName.isNotEmpty
                  ? driver.driverName
                  : "Not Available",
            ),
          ),

          // Phone
          Expanded(
            flex: 2,
            child: _Cell(driver.driverContact ?? 'Not Available'),
          ),

          // Status
          Expanded(
            child: Center(
              child: StatusBadge(
                label: statusUi.label,
                color: statusUi.color,
                display: StatusDisplay.dotOnly,
              ),
            ),
          ),

          // Actions
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.visibility),
                tooltip: 'View driver',
                onPressed: () {
                  context.pushNamed('driver_details', extra: driver);
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
