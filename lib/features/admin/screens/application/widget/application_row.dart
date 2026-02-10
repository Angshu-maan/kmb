import 'package:flutter/material.dart';
import '../model/application_model.dart';
import '../../../widgets/status_badge.dart';

class ApplicationRow extends StatelessWidget {
  final ApplicationModel kmbApplication;

  const ApplicationRow({
    super.key,
    required this.kmbApplication,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _Cell(kmbApplication.applicationId ?? '-', flex: 2),
          // _Cell(kmbApplication.s, flex: 2),

          // Status column
          Expanded(
            child: StatusBadge(active: kmbApplication.kmbActive),
          ),

          // Actions column
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  tooltip: 'View Application',
                  onPressed: () {
                    
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// Table Cell
/// ===============================
class _Cell extends StatelessWidget {
  final String text;
  final int flex;

  const _Cell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
