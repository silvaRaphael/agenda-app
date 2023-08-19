import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:agenda/utils/constants.dart';

class GoBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime? day;

  const GoBackAppBar({this.day, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      foregroundColor: AppColors.primary,
      centerTitle: false,
      backgroundColor: AppColors.white,
      elevation: 0,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(day),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.keyboard_arrow_left, size: 22),
                ),
              ),
              const Text(
                'Voltar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
