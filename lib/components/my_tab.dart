import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  final List<Widget> children;
  const MyTab({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight:
                MediaQuery.of(context).size.height - kToolbarHeight * 1.9,
          ),
          child: Column(
            children: [
              ...children,
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
