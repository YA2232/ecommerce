import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final int subtotal;
  final int deliveryFee;

  const OrderSummary(
      {super.key, required this.subtotal, required this.deliveryFee});

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        _buildSummaryRow('Subtotal', '\$$subtotal'),
        _buildSummaryRow('Delivery Fee', '\$$deliveryFee'),
        const Divider(),
        _buildSummaryRow('Total', '\$$total', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
