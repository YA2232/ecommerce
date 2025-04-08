import 'package:ecommerce/data/model/add_food_item.dart';
import 'package:ecommerce/presentation/screens/home/widgets/food_item_card.dart';
import 'package:flutter/material.dart';

class VerticalFoodList extends StatelessWidget {
  final List<AddFoodItem> items;

  const VerticalFoodList({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => FoodItemCard(item: items[index]),
    );
  }
}
