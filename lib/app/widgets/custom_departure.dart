import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';
import '../modules/single_tour/controllers/single_tour_controller.dart';
import 'custom_elevated_button.dart';
import 'custom_textformfield.dart';
import 'customdatepicker.dart';

class CustomDeparture extends StatelessWidget {
  const CustomDeparture(
      {super.key,
      required this.controller,
      required this.countOfAdults,
      required this.countOfChildrens});
  final SingleTourController controller;
  final Widget countOfAdults;
  final Widget countOfChildrens;
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMoreFixedTours();
      }
    });
    return SizedBox(
      child: Form(
        key: controller.formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '  Adults',
                  style: subheading2,
                ),
                countOfAdults
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '  Childrens',
                  style: subheading2,
                ),
                countOfChildrens
              ],
            ),
            const SizedBox(height: 30),
            CustomDatePickerField(
              isTime: false,
              controller: controller.dateTimeController,
              labelName: 'Select Tour Date',
              validator: (String? value) => controller.tourDateValidator(value),
              onChange: (String value) => controller.tourDate.value = value,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
                controller: controller.textFieldController,
                onChanged: (String value) =>
                    controller.tourRequirements.value = value,
                validator: (String? value) {
                  return null;
                },
                hintText: 'Do you have any requirements ?!'),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Obx(() {
              return CustomButton().showIconButtonWithGradient(
                  height: 70,
                  width: 80.w,
                  isLoading: controller.isloadingEnquiryButton.value,
                  text: '      Submit Request',
                  onPressed: () => controller.onClickEnquiry());
            })
          ],
        ),
      ),
    );
  }
}
