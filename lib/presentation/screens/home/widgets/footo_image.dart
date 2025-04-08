import 'package:flutter/material.dart';

class FoodImage extends StatelessWidget {
  final String? imageUrl;

  const FoodImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : Image.asset("assets/images/welcome.jpg", fit: BoxFit.cover),
      ),
    );
  }
}
