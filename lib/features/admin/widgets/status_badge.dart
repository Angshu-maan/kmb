import 'package:flutter/material.dart';

enum StatusDisplay { dotOnly, textOnly, dotWithText }

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final StatusDisplay display;
  final double dotSize;
  final TextStyle? textStyle;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.display,
    this.dotSize = 10,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content;

    switch (display) {
      case StatusDisplay.dotOnly:
        content = _buildDot();
        break;

      case StatusDisplay.textOnly:
        content = _buildText(context);
        break;

      case StatusDisplay.dotWithText:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(),
            const SizedBox(width: 6),
            _buildText(context),
          ],
        );
        break;
    }

    return Tooltip(message: label, child: content);
  }

  Widget _buildDot() {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      label,
      style:
          textStyle ??
          Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
