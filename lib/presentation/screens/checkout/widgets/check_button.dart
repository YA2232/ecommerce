import 'package:flutter/material.dart';

class CheckoutButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const CheckoutButton(
      {super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('PLACE ORDER', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
