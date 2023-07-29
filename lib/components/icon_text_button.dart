import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyIconTextButton extends StatefulWidget {
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Future<void> Function()? asyncOnPressed;
  final void Function()? onPressed;
  final String label;
  final IconData icon;

  const MyIconTextButton({
    this.width,
    this.borderRadius,
    this.backgroundColor,
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
      width: widget.width ?? double.maxFinite,
      height: 50,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                widget.backgroundColor ?? AppColors.primary),
            elevation: const MaterialStatePropertyAll(2),
          ),
          onPressed:
              _hasError || _isLoading || _isCompleted ? null : _handlePressed,
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : _hasError
                  ? const Icon(
                      Icons.error_outline_rounded,
                      size: 28,
                      color: Colors.white,
                    )
                  : _isCompleted
                      ? const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 28,
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.label),
                            const SizedBox(width: 5),
                            Icon(
                              widget.icon,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
        ),
      ),
    );
  }
}
