import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AppAnimations.errorPage,
      repeat: false,
      fit: BoxFit.cover,
    );
  }
}
