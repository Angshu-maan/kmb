import 'package:flutter/material.dart';

class DriverDetailsRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const DriverDetailsRow({super.key,required this.left,required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16,),
        Expanded(child: right)
      ],
    );
  }
}





