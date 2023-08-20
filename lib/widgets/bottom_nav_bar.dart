import 'package:flutter/material.dart';

import 'package:agenda/utils/models.dart';
import 'package:agenda/utils/constants.dart';

class BottomNavBar extends StatelessWidget {
  final List<ModelNavBarItem> bottomNavBarItemsList;
  final int tabIndex;
  final void Function(int)? onTap;

  const BottomNavBar({
    required this.bottomNavBarItemsList,
    required this.tabIndex,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: bottomNavBarItemsList.map((item) {
              return GestureDetector(
                onTap: onTap == null ? null : () => onTap!(item.index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: item.index == tabIndex
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    item.index == tabIndex ? item.iconActive : item.icon,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
