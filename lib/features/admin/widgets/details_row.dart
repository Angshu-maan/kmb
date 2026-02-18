import 'package:flutter/material.dart';

class DetailsRow extends StatelessWidget {
  final Widget? left;
  final Widget? right;
  const DetailsRow({super.key, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (left != null) Expanded(child: left!),
        const SizedBox(height: 24),
        if (right != null) Expanded(child: right!),
      ],
    );
  }
}
