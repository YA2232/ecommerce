import 'package:ecommerce/data/model/order_model.dart';
import 'package:ecommerce/presentation/screens/order/widgets/order_card.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  const OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}
