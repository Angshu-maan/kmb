import 'package:flutter/material.dart';

class AppSearchBox extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final double width;

  const AppSearchBox({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
