import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static Color accent = const Color(0xFFA71CBC);
  static Color primary = const Color(0xFF0E2650);
  static Color secondary = const Color(0xFF1D407D);
  static Color tertiary = const Color(0xFF345FA9);

  static Color grey = const Color(0xFFE3ECED);
  static Color lightGrey = const Color(0xFFF7F4F3);
  static Color dark = const Color(0x2B2B2BFF);
  static Color white = const Color(0xFFFFFFFF);
  static Color success = const Color(0xFF6BF178);
  static Color error = const Color(0xFFFF5964);
}

SystemUiOverlayStyle navbarAccent = SystemUiOverlayStyle(
  systemNavigationBarColor: AppColors.accent,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.light,
);

SystemUiOverlayStyle navbarWhite = SystemUiOverlayStyle(
  systemNavigationBarColor: AppColors.lightGrey,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.dark,
);

SystemUiOverlayStyle navbarLight = SystemUiOverlayStyle(
  systemNavigationBarColor: AppColors.grey,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.dark,
);

SystemUiOverlayStyle navbarDark = SystemUiOverlayStyle(
  systemNavigationBarColor: AppColors.primary,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.light,
);

SystemUiOverlayStyle navbarBlack = const SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.black,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.light,
);

String randomID() {
  return (Random().nextInt(100) * pi).toString().split('.')[1];
}

String getCurrentGreeting() {
  List<String> greetings = [
    'Bom Dia',
    'Boa Tarde',
    'Boa Noite',
  ];

  int hourNow = DateTime.now().hour.toInt();

  if (hourNow >= 6 && hourNow < 12) return greetings[0];
  if (hourNow >= 12 && hourNow < 18) return greetings[1];
  return greetings[2];
}

void showMySnackBar(BuildContext context, String title, bool status) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      backgroundColor: status ? Colors.greenAccent[700] : Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
  );
}

void showMyAlert({
  required BuildContext context,
  bool? status,
  required String title,
  String? text,
  String? confirmLabel,
  void Function()? onCancel,
  required void Function() onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            status != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      status ? Icons.check_circle_outline : Icons.error_outline,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  )
                : Container(),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        content: text != null
            ? Text(
                text,
                style: TextStyle(
                  color: AppColors.primary.withOpacity(.85),
                ),
              )
            : null,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              onCancel != null
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            AppColors.primary.withOpacity(.2)),
                        elevation: const MaterialStatePropertyAll(2),
                      ),
                      onPressed: onCancel,
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onConfirm,
                child: Text(confirmLabel ?? 'Confirmar'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
