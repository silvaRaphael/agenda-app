import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  final double? size;
  final Color? color;
  final Color? backgroundColor;
  const MyIconButton({
    required this.iconData,
    this.onTap,
    this.borderRadius,
    this.size,
    this.color,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Container(
          width: size ?? 50,
          height: size ?? 50,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          child: Icon(
            iconData,
            color: color ?? Colors.white,
            size: (size ?? 50) / (50 / 22),
          ),
        ),
      ),
    );
  }
}
