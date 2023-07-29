import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle? navBar;
  final String? title;
  final bool? defaultButton;
  final bool? backButton;
  final IconData? backIcon;
  final String? backTooltip;
  final void Function()? backFunction;
  final PreferredSizeWidget? bottom;
  const MyAppBar({
    this.navBar,
    this.title,
    this.defaultButton,
    this.backButton,
    this.backIcon,
    this.backTooltip,
    this.backFunction,
    this.bottom,
    super.key,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom != null ? 20 : 0));
  // Size.fromHeight(kToolbarHeight * (bottom != null ? 2 : 1));
  // Size.fromHeight(kToolbarHeight + 20);

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
