import 'package:flutter/material.dart';

class DetailField extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool showViewIcon;
  final VoidCallback? onView;

  const DetailField({
    super.key,
    required this.label,
    required this.value,
    this.showViewIcon = false,
    this.onView,
  });
  
  String get displayValue {
    if (value == null) return "Not available";
    final str = value.toString().trim();
    if (str.isEmpty || str == 'null') return "Not available";
    return str;
  }


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
              displayValue,
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
