import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? profileImageUrl;
  final File? selectedImage;
  final VoidCallback onPressed;

  const ProfileImage({
    required this.profileImageUrl,
    required this.selectedImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    if (selectedImage != null) {
      return Image.file(selectedImage!, fit: BoxFit.cover);
    } else if (profileImageUrl == null) {
      return IconButton(
        icon: const Icon(Icons.person, size: 50, color: Colors.white),
        onPressed: onPressed,
      );
    } else {
      return GestureDetector(
        onTap: onPressed,
        child: Image.network(
          profileImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
