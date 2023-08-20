import 'package:flutter/material.dart';

class ModelNavBarItem {
  final int index;
  final IconData icon;
  final IconData iconActive;

  const ModelNavBarItem({
    required this.index,
    required this.icon,
    IconData? iconActive,
  }) : iconActive = iconActive ?? icon;
}

class ModelBillsMarkers {
  final String label;
  final Color color;
  final IconData icon;

  const ModelBillsMarkers({
    required this.label,
    required this.color,
    required this.icon,
  });
}
