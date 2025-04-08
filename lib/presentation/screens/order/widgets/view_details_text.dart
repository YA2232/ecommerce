import 'package:flutter/material.dart';

class ViewDetailsText extends StatelessWidget {
  const ViewDetailsText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'View Details',
      style: TextStyle(
        color: Colors.orange[700],
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }
}
