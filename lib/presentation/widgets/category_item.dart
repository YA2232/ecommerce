import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String pathFoto;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.pathFoto,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.orange : Colors.white,
          ),
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              pathFoto,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
