import 'package:flutter/material.dart';

class ActionItem {
  ActionItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.routeName,
  });
  final String id;
  final IconData icon;
  final String label;
  final String routeName;
}
