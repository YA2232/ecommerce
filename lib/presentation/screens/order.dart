import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/presentation/screens/checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late FirebaseCubit firebaseCubit;
  int total = 0;

  @override
  void initState() {
    super.initState();
    firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
    firebaseCubit.getFoodCart(firebaseAuth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<FirebaseCubit, FirebaseState>(
                builder: (context, state) {
                  if (state is LoadingFirebase) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SuccessedFoodCart) {
                    final listFoodCart = state.listFoodCart;
                    total = listFoodCart.fold(
                      0,
                      (sum, item) => sum + int.parse(item.price),
                    );

                    if (listFoodCart.isEmpty) {
                      return const Center(child: Text('No items in the cart'));
                    }

                    return ListView.separated(
                      itemCount: listFoodCart.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final foodCart = listFoodCart[i];

                        return ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  foodCart.image ??
                                      'https://via.placeholder.com/150',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(foodCart.name ?? 'Not found'),
                          subtitle: Text('Quantity: ${foodCart.quantity ?? 0}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${foodCart.price ?? 0} \$'),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  firebaseCubit.removeFromCart(
                                    firebaseAuth.currentUser!.uid,
                                    foodCart.id,
                                  );
                                },
                                child: const Icon(Icons.remove_circle_outline),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('Failed to load cart'));
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total price:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                BlocBuilder<FirebaseCubit, FirebaseState>(
                  builder: (context, state) {
                    if (state is SuccessedFoodCart) {
                      return Text(
                        '\$${total.toString()}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.teal),
                      );
                    }
                    return const Text(
                      '\$0',
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (total > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Checkout(
                        totalPrice: total,
                        list: (BlocProvider.of<FirebaseCubit>(context).state
                                as SuccessedFoodCart)
                            .listFoodCart,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
