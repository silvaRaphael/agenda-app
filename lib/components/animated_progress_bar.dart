import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyAnimatedProgressBar extends StatefulWidget {
  final Curve? curve;
  final Duration? duration;
  const MyAnimatedProgressBar({
    this.curve,
    this.duration,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyAnimatedProgressBarState createState() => _MyAnimatedProgressBarState();
}

class _MyAnimatedProgressBarState extends State<MyAnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 750),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve ?? Curves.linear,
    ).drive(Tween<double>(begin: 0, end: 100));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return LinearProgressIndicator(
          value: _animation.value / 100,
          backgroundColor: AppColors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        );
      },
    );
  }
}
