import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ecommerce/presentation/screens/order/widgets/order_tab.dart';
import 'package:flutter/material.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: OrderStatus.values.length,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          color: Colors.grey[100],
          child: const TabBarView(
            children: [
              OrderTab(status: OrderStatus.newOrder),
              OrderTab(status: OrderStatus.transported),
              OrderTab(status: OrderStatus.delivered),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'My Orders',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.orange,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ButtonsTabBar(
            radius: 30,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            backgroundColor: Colors.orange,
            unselectedBackgroundColor: Colors.white,
            borderWidth: 0,
            unselectedBorderColor: Colors.transparent,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: OrderStatus.values.map((status) {
              return Tab(text: status.displayName);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

enum OrderStatus {
  newOrder('New Order'),
  transported('Shipped'),
  delivered('Delivered');

  final String displayName;
  const OrderStatus(this.displayName);

  String get value {
    switch (this) {
      case OrderStatus.newOrder:
        return "new order";
      case OrderStatus.transported:
        return "transported";
      case OrderStatus.delivered:
        return "delivered";
    }
  }
}
