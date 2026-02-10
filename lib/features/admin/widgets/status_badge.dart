import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool active;
  final double size;

  const StatusBadge({
    super.key,
    required this.active,
    this.size = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: active ? 'Active' : 'Inactive',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: active ? Colors.green : Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
