import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/images.dart';
import '../controllers/nointernet_controller.dart';

class NointernetView extends GetView<NointernetController> {
  const NointernetView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(noInternetImage),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14),
              child: Text(
                'No intertent , \n Please Check Your Connection And try again',
                style: subheading3,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Obx(() {
                return CustomButton().showIconButtonWithGradient(
                  isLoading: controller.isLoading.value,
                  width: double.infinity,
                  height: 70,
                  text: '      try again',
                  onPressed: () => controller.checkConnection(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
