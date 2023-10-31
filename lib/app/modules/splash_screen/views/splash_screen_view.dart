import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import '../../../widgets/images.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          homeScreenLogo,
          width: 60.w,
        ),
      ),
    );
  }
}
