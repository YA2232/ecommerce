import 'package:flutter/material.dart';

class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No available data",
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),
    );
  }
}
