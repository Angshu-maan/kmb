import 'package:flutter/material.dart';

class DriversDetailField extends StatelessWidget {
  final String label;
  final String value;
  final bool showViewIcon;
  final VoidCallback? onView;

  const DriversDetailField({
    super.key,
    required this.label,
    required this.value,
    this.showViewIcon = false,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 78, 78, 78),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showViewIcon && onView != null)
              InkWell(
                onTap: onView,
                child: const Icon(Icons.visibility, size: 18),
              ),
          ],
        ),
      ],
    );
  }
}
