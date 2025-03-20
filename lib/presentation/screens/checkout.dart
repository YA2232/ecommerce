import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/data/model/order_model.dart';
import 'package:ecommerce/presentation/screens/bottomnav.dart';
import 'package:ecommerce/presentation/screens/success.dart';
import 'package:ecommerce/services/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';

class Checkout extends StatefulWidget {
  List<AddToCart> list;
  int totalPrice;

  Checkout({required this.list, required this.totalPrice, super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int priceOfDelivery = 50;

  final PaymentService paymentService = PaymentService();

  late FirebaseCubit firebaseCubit;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();

  final TextEditingController phone = TextEditingController();

  final TextEditingController address = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      "Submit Order :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2)),
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the phone number";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2)),
                          hintText: "phone number",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.phone_android_outlined)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      cursorColor: Colors.grey,
                      controller: address,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the address";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2)),
                          hintText: "address",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.place_outlined)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    widget.totalPrice.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    priceOfDelivery.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Summary: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    (widget.totalPrice + priceOfDelivery).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  final String orderId = randomAlphaNumeric(10);
                  if (formKey.currentState!.validate()) {
                    // paymentService.makePayment(context,
                    //     (widget.totalPrice + priceOfDelivery).toString());
                    firebaseCubit
                        .addOrder(OrderModel(
                            orderId: orderId,
                            userId: firebaseAuth.currentUser!.uid,
                            name: name.text,
                            address: address.text,
                            phone: phone.text,
                            totalPrice: (widget.totalPrice + priceOfDelivery)
                                .toDouble(),
                            list: widget.list.map((e) => e.toJson()),
                            status: "قيد المراجعه",
                            createdAt: DateTime.now()))
                        .then((_) {
                      firebaseCubit.clearCart(firebaseAuth.currentUser!.uid);
                    });
                  }
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Success()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFFff5c30),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
