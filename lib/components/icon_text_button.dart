import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyIconTextButton extends StatefulWidget {
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? color;
  final Future<void> Function()? asyncOnPressed;
  final void Function()? onPressed;
  final String label;
  final IconData icon;

  const MyIconTextButton({
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.color,
    this.asyncOnPressed,
    this.onPressed,
    required this.label,
    required this.icon,
    super.key,
  });

  @override
  State<MyIconTextButton> createState() => _MyIconTextButtonState();
}

class _MyIconTextButtonState extends State<MyIconTextButton> {
  late bool _isLoading;
  late bool _isCompleted;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isCompleted = false;
    _hasError = false;
  }

  Future<void> _handlePressed() async {
    if (widget.asyncOnPressed != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.asyncOnPressed!();
      } catch (e) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _isLoading = false;
          _hasError = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
        _isCompleted = true;
      });
    } else {
      if (widget.onPressed != null) {
        widget.onPressed!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 55,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              widget.backgroundColor ?? AppColors.primary,
            ),
            elevation: const MaterialStatePropertyAll(8),
          ),
          onPressed:
              _hasError || _isLoading || _isCompleted ? null : _handlePressed,
          child: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: widget.color ?? AppColors.white,
                  ),
                )
              : _hasError
                  ? Icon(
                      Icons.error_outline_rounded,
                      size: 28,
                      color: widget.color ?? AppColors.white,
                    )
                  : _isCompleted
                      ? Icon(
                          Icons.check_circle_outline_rounded,
                          size: 28,
                          color: widget.color ?? AppColors.white,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.icon,
                                size: 24,
                                color: widget.color ?? AppColors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.label,
                                style: TextStyle(
                                  color: widget.color ?? AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}
