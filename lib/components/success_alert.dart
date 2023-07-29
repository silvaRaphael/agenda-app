import 'package:flutter/material.dart';

import 'package:agenda/components/loading_check_animated.dart';
import 'package:agenda/components/icon_text_button.dart';

import 'package:agenda/utils/constants.dart';

void showSuccessAlert(BuildContext context,
    {required String title,
    required String content,
    required String buttonLabel,
    required void Function() onClose}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actionsPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        title: Column(
          children: [
            const MyLoadingCheckAnimated(),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                color: AppColors.success,
              ),
            ),
          ],
        ),
        content: Text(content),
        actions: [
          MyIconTextButton(
            label: buttonLabel,
            icon: Icons.arrow_forward,
            onPressed: onClose,
          ),
        ],
      );
    },
  );
}
