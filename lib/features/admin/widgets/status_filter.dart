import 'package:flutter/material.dart';
enum StatusFilter {
  active,
  inactive,
}


class StatusFilterToggle extends StatelessWidget {
  final StatusFilter selected;
  final ValueChanged<StatusFilter> onChanged;

  final String activeLabel;
  final String inactiveLabel;

  const StatusFilterToggle({
    super.key,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _chip(
          context,
          label: activeLabel,
          selected: selected == StatusFilter.active,
          onTap: () => onChanged(StatusFilter.active),
        ),
        _chip(
          context,
          label: inactiveLabel,
          selected: selected == StatusFilter.inactive,
          onTap: () => onChanged(StatusFilter.inactive),
        ),
      ],
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary,
      // backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
