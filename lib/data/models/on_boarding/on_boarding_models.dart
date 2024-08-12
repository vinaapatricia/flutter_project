import 'package:flutter_project/configs/assets/app_images.dart';

class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
      title: 'Easy products and sales management',
      image: AppImages.onBoarding1,
      description:
          "Effortlessly manage all your store transactions and products in one app"),
  UnboardingContent(
      title: 'Choose your own payment method',
      image: AppImages.onBoarding2,
      description:
          "Seamless payout with various payment method you can choose from"),
  UnboardingContent(
      title: 'Manage branch  without worries',
      image: AppImages.onBoarding3,
      description:
          "Track all your store branches and operation with confidence"),
];
