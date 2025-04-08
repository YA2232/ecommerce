import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final bool isActive;

  const PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: isActive ? 18 : 9,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
