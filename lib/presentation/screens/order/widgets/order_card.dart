import 'package:ecommerce/data/model/order_model.dart';
import 'package:ecommerce/presentation/screens/order/details_order.dart';
import 'package:ecommerce/presentation/screens/order/widgets/order_state_badge.dart';
import 'package:ecommerce/presentation/screens/order/widgets/view_details_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToOrderDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              const SizedBox(height: 12),
              _buildOrderDate(),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _buildOrderFooter(),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToOrderDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsOrder(orderModel: order),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order #${order.orderId.substring(0, 8)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        OrderStatusBadge(status: order.status),
      ],
    );
  }

  Widget _buildOrderDate() {
    return Text(
      DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt),
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 13,
      ),
    );
  }

  Widget _buildOrderFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            Text(
              '\$${order.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerRight,
          child: ViewDetailsText(),
        ),
      ],
    );
  }
}
