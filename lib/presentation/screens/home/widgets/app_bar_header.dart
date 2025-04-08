import 'package:ecommerce/presentation/screens/home/widgets/shipping_cart_button.dart';
import 'package:ecommerce/presentation/screens/home/widgets/welcome_message.dart';
import 'package:flutter/material.dart';

class AppBarHeader extends StatelessWidget {
  const AppBarHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const WelcomeMessage(),
          ShoppingCartButton(),
        ],
      ),
    );
  }
}
