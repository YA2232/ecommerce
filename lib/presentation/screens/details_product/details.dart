import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_to_cart.dart';
import 'package:ecommerce/presentation/screens/details_product/widgets/bottom_cart_bar.dart';
import 'package:ecommerce/presentation/screens/details_product/widgets/header_image_with_backbutton.dart';
import 'package:ecommerce/presentation/screens/details_product/widgets/product_info)section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';

class Details extends StatefulWidget {
  final String name, price, details, image;

  const Details({
    super.key,
    required this.details,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late FirebaseCubit firebaseCubit;
  int quantity = 1;
  late int total;

  @override
  void initState() {
    super.initState();
    firebaseCubit = BlocProvider.of<FirebaseCubit>(context);
    total = int.parse(widget.price);
  }

  void _updateQuantity(bool increment) {
    setState(() {
      if (increment) {
        quantity++;
        total += int.parse(widget.price);
      } else if (quantity > 1) {
        quantity--;
        total -= int.parse(widget.price);
      }
    });
  }

  void _addToCart() async {
    String productId = randomAlphaNumeric(10);
    await firebaseCubit.addToCart(
      AddToCart(
        id: productId,
        name: widget.name,
        price: total.toString(),
        image: widget.image,
        details: widget.details,
        quantity: quantity.toString(),
      ),
      FirebaseAuth.instance.currentUser!.uid,
      productId,
      context,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Item added to cart"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderImageWithBackButton(imageUrl: widget.image),
              ProductInfoSection(
                name: widget.name,
                details: widget.details,
                quantity: quantity,
                onQuantityChanged: _updateQuantity,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomCartBar(
        total: total,
        onAddToCart: _addToCart,
      ),
    );
  }
}
