import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyLoadingCircular extends StatelessWidget {
  final String text;
  const MyLoadingCircular({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
