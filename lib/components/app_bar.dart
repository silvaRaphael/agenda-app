import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle? navBar;
  final String? title;
  final bool? defaultButton;
  final bool? backButton;
  final IconData? backIcon;
  final String? backTooltip;
  final void Function()? backFunction;
  final PreferredSizeWidget? bottom;
  bool? hidden = false;
  MyAppBar({
    this.navBar,
    this.title,
    this.defaultButton,
    this.backButton,
    this.backIcon,
    this.backTooltip,
    this.backFunction,
    this.bottom,
    this.hidden,
    super.key,
  });

  @override
  Size get preferredSize => hidden != null && hidden!
      ? const Size.fromHeight(0)
      : Size.fromHeight(kToolbarHeight + (bottom != null ? 20 : 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      systemOverlayStyle: navBar,
      title: title == null ? null : Text(title!),
      leading: defaultButton != null && defaultButton!
          ? null
          : backButton != null && !backButton!
              ? Container()
              : IconButton(
                  icon: Icon(backIcon ?? Icons.arrow_back),
                  onPressed: backFunction ??
                      () {
                        Navigator.pop(context);
                      },
                  tooltip: backTooltip ?? 'Voltar',
                ),
      bottom: bottom,
    );
  }
}
