import 'package:ecommerce/presentation/screens/order/my_order_tracking.dart';
import 'package:flutter/material.dart';

class ShoppingCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrderTracking()),
        ),
      ),
    );
  }
}
