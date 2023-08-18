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

class ModelAgendamento {
  final String name;
  final DateTime date;
  final double value;
  final int type;
  final bool entry;

  const ModelAgendamento({
    required this.name,
    required this.date,
    required this.value,
    required this.type,
    required this.entry,
  });
}
