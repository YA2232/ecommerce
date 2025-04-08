import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/presentation/screens/home/widgets/food_item_card.dart';
import 'package:flutter/material.dart';

class HorizontalFoodList extends StatelessWidget {
  final List<AddFoodItem> items;

  const HorizontalFoodList({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => SizedBox(
          width: 180,
          child: FoodItemCard(item: items[index]),
        ),
      ),
    );
  }
}
