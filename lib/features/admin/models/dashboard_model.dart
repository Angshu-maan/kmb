import 'package:flutter/material.dart';

class DashboardModel {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  DashboardModel({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });
}


  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(icon, size: 36, color: color),
  //           const SizedBox(height: 12),
  //           Text(
  //             value,
  //             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 6),
  //           Text(
  //             title,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(fontSize: 13),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
// }
