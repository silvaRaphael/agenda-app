import 'dart:core';

import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyLoadingCheckAnimated extends StatefulWidget {
  final double? size;
  final Color? color;
  final VoidCallback? onCompleted;
  const MyLoadingCheckAnimated({
    this.color,
    this.size,
    this.onCompleted,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyLoadingCheckAnimatedState createState() => _MyLoadingCheckAnimatedState();
}

class _MyLoadingCheckAnimatedState extends State<MyLoadingCheckAnimated>
    with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  late Animation<double> scaleAnimation = CurvedAnimation(
    parent: scaleController,
    curve: Curves.elasticOut,
  );
  late AnimationController checkController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late Animation<double> checkAnimation = CurvedAnimation(
    parent: checkController,
    curve: Curves.linear,
  );

  @override
  void initState() {
    super.initState();

    scaleController.reset();
    checkController.reset();

    scaleController.forward();
    checkController.forward();

    if (widget.onCompleted != null) {
      scaleAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onCompleted!();
        }
      });
    }
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = widget.size ?? 100;
    double iconSize = circleSize * .7;

    return SizedBox(
      height: circleSize,
      width: circleSize,
      child: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                height: circleSize,
                width: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: circleSize * .06,
                    color: widget.color ?? AppColors.success,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: circleSize,
            width: circleSize,
            child: Stack(
              children: [
                SizeTransition(
                  sizeFactor: checkAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      // color: Colors.white,
                      color: widget.color ?? AppColors.success,
                      size: iconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
