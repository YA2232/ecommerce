import 'package:ecommerce/data/model/category.dart';
import 'package:ecommerce/presentation/screens/home/widgets/category_chip.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategorySelector({
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => CategoryChip(
          category: categories[index],
          isSelected: selectedIndex == index,
          onSelected: () => onCategorySelected(index),
        ),
      ),
    );
  }
}
