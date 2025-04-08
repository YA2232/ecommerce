import 'dart:io';

import 'package:ecommerce/presentation/screens/profile/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final File? selectedImage;
  final String userName;
  final String userEmail;
  final VoidCallback onImagePressed;

  const ProfileHeader({
    required this.profileImageUrl,
    required this.selectedImage,
    required this.userName,
    required this.userEmail,
    required this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          child: Column(
            children: [
              ProfileImage(
                profileImageUrl: profileImageUrl,
                selectedImage: selectedImage,
                onPressed: onImagePressed,
              ),
              const SizedBox(height: 15),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userEmail,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
