import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/data/model/order_model.dart';
import 'package:flutter/material.dart';

class DetailsOrder extends StatelessWidget {
  DetailsOrder({required this.orderModel, super.key});

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    List<AddToCart> items = (orderModel.list as List)
        .map((e) => AddToCart.fromJson(e as Map<String, dynamic>))
        .toList();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Material(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Center(
                  child: Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                          text: 'OrderId: ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: '${orderModel.orderId}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ])),
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                          text: 'Status: ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: '${orderModel.status} ',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )
                      ])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Items: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: '${items.length} ',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ])),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final foodCart = items[i];
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            foodCart.image ?? 'https://via.placeholder.com/150',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(foodCart.name ?? 'Not found'),
                    subtitle: Text('Quantity: ${foodCart.quantity ?? 0}'),
                    trailing: Text('${foodCart.price ?? 0} \$'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
