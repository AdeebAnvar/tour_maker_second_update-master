import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/custom_textformfield.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: fontColor,
        ),
      ),
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (LoginView? state) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ALMOST \nTHERE',
                  style: TextStyle(
                    fontFamily: 'Mesa',
                    color: englishViolet,
                    fontSize: 44,
                  ),
                ),
                Text(
                  'Enter your credentials here',
                  style: subheading2,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFormField(
                          keyboardType: TextInputType.name,
                          validator: (String? value) =>
                              controller.usernameValidator(value),
                          onChanged: (String? value) =>
                              controller.name.value = value.toString(),
                          hintText: 'name',
                        ),
                        const SizedBox(height: 10),
                         CustomTextFormField(
                            onChanged: (String value) =>
                                controller.userState.value = value,
                            validator: (String? value) =>
                                controller.validateState(value),
                            hintText: 'State',
                            // initialValue: controller.userState.value,
                          ),
                      
                        // CustomDropDownButton(
                        //   lists: controller.states,
                        //   onChange: (int index, String value) =>
                        //       controller.state.value = value,
                        //   initialValue: controller.state.value,
                        // ),

                        Obx(() => CustomButton().showIconButtonWithGradient(
                              height: 72,
                              isLoading: controller.isLoading.value,
                              width: 100.w,
                              text: '     Continue',
                              onPressed: () =>
                                  controller.onClickContinue(context),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
