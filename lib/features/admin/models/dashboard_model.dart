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
