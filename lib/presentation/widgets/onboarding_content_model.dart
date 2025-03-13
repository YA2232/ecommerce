class OnboardingContentModel {
  final String title;
  final String description;
  final String image;

  OnboardingContentModel({
    required this.title,
    required this.description,
    required this.image,
  });

  static List<OnboardingContentModel> contents = [
    OnboardingContentModel(
      title: "Welcome to Our Restaurant",
      description: "Enjoy the finest dishes and fresh meals every day.",
      image: "assets/images/onboardingone.PNG",
    ),
    OnboardingContentModel(
      title: "Variety of Dishes",
      description: "We offer a wide menu to suit all tastes.",
      image: "assets/images/onboardingtwo.PNG",
    ),
    OnboardingContentModel(
      title: "Easy and Fast Orders",
      description:
          "Order your favorite meal and enjoy exceptional delivery service.",
      image: "assets/images/onboardingthree.PNG",
    ),
  ];
}
