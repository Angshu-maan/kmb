import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_mapper.dart';
import '../model/application_model.dart';
import '../../../widgets/status_badge.dart';

class ApplicationRow extends StatelessWidget {
  final ApplicationModel kmbApplication;

  const ApplicationRow({super.key, required this.kmbApplication});

  @override
  Widget build(BuildContext context) {
    final statusUi = mapStatus(
      status: kmbApplication.status,
      type: StatusType.application,
    );
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Cell(kmbApplication.applicationNo, flex: 2),

          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(
                label: statusUi.label,
                color: statusUi.color,
                display: StatusDisplay.textOnly,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.visibility),
                tooltip: 'View Application',
                onPressed: () {
                  context.pushNamed(
                    'application_details',
                    extra: kmbApplication,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final int flex;

  const _Cell(this.text, {this.flex = 2});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
