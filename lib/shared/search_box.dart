import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  // final ValueChanged<String> onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all( color: Theme.of(context).cardColor,),
      ),
      child: TextField(
        controller: controller,
        // onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyMedium,
        inputFormatters: [
          // FilteringTextInputFormatter.allow(
          //   RegExp(r'[A-Z0-9/]'),
          // ),
        ],
        decoration: InputDecoration(
          hintText: 'Type application ID or name',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    // onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
