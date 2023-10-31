import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_textformfield.dart';
import '../../../widgets/images.dart';
import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Image.asset(
            getStartedImage,
            fit: BoxFit.cover,
            width: 100.w,
            height: 100.h,
          ),
          Positioned(
            top: 14.h,
            left: 10.w,
            child: SvgPicture.asset(
              getStartedLogo,
            ),
          ),
          Positioned(
            top: 50.h,
            left: 10.w,
            child: Column(
              children: <Widget>[
                const Text(
                  "LET'S \nGET\nSTARTED",
                  style: TextStyle(
                    fontFamily: 'Mesa',
                    fontWeight: FontWeight.w800,
                    fontSize: 38,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'WE MAKE YOUR DREAM TO REALITY',
                  style: TextStyle(
                    fontFamily: 'Mesa',
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 20),
              child: CustomButton().showIconButtonWithGradient(
                height: 72,
                width: 100.w,
                text: '     Continue',
                onPressed: () => onClickContinue(context),
              ),
            ),
          ),
          // const SizedBox(height: 40),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 20),
          //     child: GestureDetector(
          //       onTap: () => controller.onClickDemoOfTheApp(),
          //       child: Text(
          //         'guest login',
          //         style: subheading1.copyWith(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void onClickContinue(BuildContext context) {
    Get.bottomSheet(
        enterBottomSheetDuration: const Duration(milliseconds: 600),
        exitBottomSheetDuration: const Duration(milliseconds: 600),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        controller.obx(
          (dynamic state) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 22),
              child: SizedBox(
                // height: 50.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Welcome To TourMaker',
                      style: heading3,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Insert your phone number to continue',
                      style: paragraph3,
                    ),                    SizedBox(height: 20),

                    Form(
                      key: controller.formKey,
                      child: Obx(() {
                        return CustomTextFormField(
                          // maxLength: 10,
                          enabled: !controller.isloading.value,
                          keyboardType: TextInputType.phone,
                          validator: (String? value) =>
                              controller.phoneNumberValidator(value!),
                          onChanged: (String? value) =>
                              controller.phone = value,
                          hintText: 'Phone number',
                          prefixIcon: Obx(() {
                            return GestureDetector(
                              onTap: () =>
                                  controller.onCountryCodeClicked(context),
                              child: Container(
                                width: 35,
                                margin:
                                    const EdgeInsets.only(right: 10, left: 12),
                                height: 35,
                                decoration: const BoxDecoration(
                                    // color: Colors.red,
                                    // borderRadius: BorderRadius.circular(40),
                                    ),
                                clipBehavior: Clip.hardEdge,
                                child: Center(
                                  child: Text(
                                    controller.selectedCountry.value.flagEmoji,
                                    style: const TextStyle(fontSize: 35),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                    Obx(
                      () => CustomButton().showIconButtonWithGradient(
                        height: 72,
                        isLoading: controller.isloading.value,
                        width: 100.w,
                        text: '     Continue',
                        onPressed: () => controller.onVerifyPhoneNumber(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )).then((dynamic value) => controller.isloading.value = false);
  }
}
