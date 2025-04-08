import 'package:ecommerce/bissness_logic/firebase/cubit/firebase_cubit.dart';
import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/presentation/screens/details_product/details.dart';
import 'package:ecommerce/presentation/screens/home/widgets/food_details.dart';
import 'package:ecommerce/presentation/screens/home/widgets/footo_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodItemCard extends StatelessWidget {
  final AddFoodItem item;

  const FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoodImage(imageUrl: item.image),
            FoodDetails(item: item),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToDetails(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(
          details: item.details,
          name: item.name,
          price: item.price,
          image: item.image!,
        ),
      ),
    );
    context.read<FirebaseCubit>().getFoodItem(item.name);
  }
}
