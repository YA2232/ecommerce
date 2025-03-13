import 'dart:async';
import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Order extends StatefulWidget {
  Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late String id, wallet;
  int total = 0, amount2 = 0;

  void startTimer() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          amount2 = total;
        });
      }
    });
  }

  getsharedPref() async {
    id = (await SharedPrefrenceHelper().getUserId()) ?? '';
    wallet = (await SharedPrefrenceHelper().getUserWallet()) ?? '0';
    BlocProvider.of<FirebaseCubit>(context, listen: false).getFoodCart(id);
  }

  Widget getFoodCart() {
    return BlocBuilder<FirebaseCubit, FirebaseState>(builder: (context, state) {
      if (state is LoadingFirebase) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SuccessedFoodCart) {
        List<AddToCart> listFoodCart = state.listFoodCart;
        total = 0;

        return ListView.separated(
          itemCount: listFoodCart.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, i) {
            AddToCart foodCart = listFoodCart[i];
            total += int.parse(foodCart.price);

            return ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                        foodCart.image ?? 'https://via.placeholder.com/150'),
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
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        BlocProvider.of<FirebaseCubit>(context)
                            .removeFromCart(id, foodCart.id);
                      },
                      child: Icon(Icons.remove_circle_outline))
                ],
              ),
            );
          },
        );
      }
      return Container();
    });
  }

  @override
  void initState() {
    super.initState();
    getsharedPref();
    startTimer();
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
            Expanded(child: getFoodCart()),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total price:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$' + total.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int amount = int.parse(wallet) - amount2;
                await BlocProvider.of<FirebaseCubit>(context, listen: false)
                    .updateUserWallet(amount.toString(), id);
                await SharedPrefrenceHelper().saveUserWallet(amount.toString());
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
