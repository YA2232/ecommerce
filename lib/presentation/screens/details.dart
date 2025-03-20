import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/data/model/shared_prefrence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';

class Details extends StatefulWidget {
  String name;
  String price;
  String details;
  String image;
  Details(
      {required this.details,
      required this.image,
      required this.name,
      required this.price,
      super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late FirebaseCubit firebaseCubit;
  SharedPrefrenceHelper sharedprefCubit = SharedPrefrenceHelper();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? userId;
  Future<void> getthesharedref() async {
    userId = firebaseAuth.currentUser!.uid;
  }

  int quantity = 1, total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
    getthesharedref();
    total = int.parse(widget.price);
    int totaPrice() {
      return quantity * total;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new),
            ),
            Image.network(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                        total -= int.parse(widget.price);
                      });
                    } else {
                      return;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0XFF008080),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(quantity.toString()),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                      total += int.parse(widget.price);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0XFF008080),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.details,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              children: [
                Text(
                  "Delivery Time:",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.alarm,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "30 Minute",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$" + total.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      String productId = randomAlphaNumeric(10);
                      await firebaseCubit.addToCart(
                          AddToCart(
                              id: productId,
                              name: widget.name,
                              price: total.toString(),
                              image: widget.image,
                              details: widget.details,
                              quantity: quantity.toString()),
                          userId!,
                          productId,
                          context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text("Food Added To Cart")));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0XFF008080),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
