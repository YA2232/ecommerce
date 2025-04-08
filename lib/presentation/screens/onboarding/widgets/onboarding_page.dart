import 'package:ecommerce/presentation/widgets/onboarding_content_model.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingContentModel content;

  const OnboardingPage({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildImage(),
          const SizedBox(height: 40),
          _buildTitle(),
          const SizedBox(height: 20),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      content.image,
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTitle() {
    return Text(
      content.title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      content.description,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }
}
