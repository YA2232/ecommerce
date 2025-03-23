import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/order_model.dart';
import 'package:ecommerce/presentation/screens/details_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyOrderTracking extends StatelessWidget {
  MyOrderTracking({super.key});
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FirebaseCubit()..getOrderUser(firebaseAuth.currentUser!.uid),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Orders',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.orange,
          ),
          body: Column(
            children: <Widget>[
              ButtonsTabBar(
                contentPadding: EdgeInsets.all(10),
                radius: 5,
                backgroundColor: Colors.red,
                borderWidth: 1.5,
                unselectedBorderColor: Colors.transparent,
                elevation: 5,
                buttonMargin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                borderColor: Colors.transparent,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: "New Order"),
                  Tab(text: "Transported"),
                  Tab(text: "Delivered"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOrderTab("new order"),
                    _buildOrderTab("transported"),
                    _buildOrderTab("delivered"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTab(String status) {
    return BlocBuilder<FirebaseCubit, FirebaseState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrdersUserLoaded) {
          List<OrderModel> orders =
              state.list.where((order) => order.status == status).toList();

          return _buildOrderList(orders);
        }
        return const Center(child: Text("No available data"));
      },
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text("No Orders found"));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        String formattedDate = DateFormat('yyyy-MM-dd').format(order.createdAt);
        return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OrderId: ${order.orderId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        order.status,
                        style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'Quantity: ',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: '${formattedDate}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ])),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'Total Amount: ',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: '${order.totalPrice} \$',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ])),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsOrder(
                                        orderModel: order,
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Details",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildButtonStatus(
      String text, BuildContext context, String orderId, String newStatus) {
    return GestureDetector(
      onTap: () {
        context.read<FirebaseCubit>().updateOrderStatus(orderId, newStatus);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "new order":
        return Colors.orange;
      case "transported":
        return Colors.blue;
      case "delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
