import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyInlineRadio extends StatelessWidget {
  final String label;
  final dynamic value;
  final dynamic selected;
  final Function() onChanged;
  const MyInlineRadio({
    required this.label,
    required this.value,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged();
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selected,
            onChanged: (valor) {
              onChanged();
            },
            activeColor: AppColors.primary,
          ),
          Text(label),
        ],
      ),
    );
  }
}
