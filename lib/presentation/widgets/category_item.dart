import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String pathFoto;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.pathFoto,
    required this.name,
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
            color: isSelected ? Colors.blue : Colors.white,
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  pathFoto,
                  width: 50,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Text(name)
            ],
          ),
        ),
      ),
    );
  }
}
