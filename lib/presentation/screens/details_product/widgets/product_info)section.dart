import 'package:ecommerce/presentation/screens/details_product/widgets/quantity_selector_widget.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final String name;
  final String details;
  final int quantity;
  final void Function(bool) onQuantityChanged;

  const ProductInfoSection({
    super.key,
    required this.name,
    required this.details,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              QuantitySelectorWidget(
                quantity: quantity,
                onChanged: onQuantityChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            details,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.teal),
              const SizedBox(width: 8),
              Text(
                "Delivery in 30 minutes",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
