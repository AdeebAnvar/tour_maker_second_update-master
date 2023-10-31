import 'dart:developer';

import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';

import '../../../services/custom_functions/firebase_functions.dart' as firebase;

class GetStartedController extends GetxController with StateMixin<dynamic> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isloading = false.obs;

  String? phone;

  Rx<Country> selectedCountry = Country(
          phoneCode: '91',
          countryCode: 'IN',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'India',
          example: 'India',
          displayName: 'India',
          displayNameNoCountryCode: 'IN',
          e164Key: '')
      .obs;

  @override
  void onInit() {
    super.onInit();

    change(null, status: RxStatus.success());
  }

  void onCountryCodeClicked(BuildContext context) => showCountryPicker(
        countryListTheme: CountryListThemeData(
          backgroundColor: Colors.white,
          bottomSheetHeight: 500,
          textStyle: subheading1,
        ),
        context: context,
        onSelect: (Country value) => selectedCountry.value = value,
      );

  Future<void> onVerifyPhoneNumber() async {
    if (formKey.currentState!.validate()) {
      isloading.value = true;

      final String phoneNumber = '+${selectedCountry.value.phoneCode}$phone';

      try {
        await firebase.sendPhoneNumberToFirebase(
            phoneNumber: phoneNumber, isLoading: isloading.value);
      } catch (e) {
        log('verifyPhoe $e');
        isloading.value = false;
      }
    }
  }

  String? phoneNumberValidator(String value) =>
      GetUtils.isLengthEqualTo(value, 10)
          ? null
          : 'Please enter a valid phone number';

  Future<void> onClickDemoOfTheApp() async {
    const String phoneNumber = '+918330075573';

    await firebase.gustUserLogin(
        phoneNumber: phoneNumber, isloading: isloading.value);
  }
}
