import 'package:flutter/material.dart';

enum StatusFilter { active, inactive }

enum ApplicationFilter { newApp, approved, rejected, issued }

enum ApplicationAction { accept, reject, revert, sendToDeal }

class StatusFilterToggle<T extends Enum> extends StatelessWidget {
  final T selected;
  final ValueChanged<T> onChanged;
  final List<T> values;
  final String Function(T value) labelBuilder;

  const StatusFilterToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.values,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: values.map((value) {
        final isSelected = value == selected;

        final isActive = value == StatusFilter.active;

        final selectedColor = isActive ? Colors.green : Colors.grey.shade700;

        final unselectedColor = isActive
            ? Colors.green.withOpacity(0.12)
            : Colors.grey.withOpacity(0.15);

        final icon = isActive
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;

        return GestureDetector(
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? selectedColor
                    : selectedColor.withOpacity(0.4),
                width: 1.4,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: selectedColor.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.05 : 1,
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : selectedColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    labelBuilder(value),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : selectedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
