import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/utils/constants.dart';
import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/user_registerscreen_view.dart';

class UserRegisterscreenController extends GetxController
    with StateMixin<UserRegisterscreenView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<UserModel> user = UserModel().obs;
  GetStorage getStorage = GetStorage();
  late Razorpay razorPay;
  Rx<RazorPayModel> razorPayModel = RazorPayModel().obs;
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
    e164Key: '',
  ).obs;
  Rx<Gender> selectedGender = Gender.Male.obs;
  Rx<CategoryType> selectedCategoryType = CategoryType.standard.obs;
  RxBool isloading = false.obs;
  RxBool isPaidInitial = false.obs;
  Rx<bool> isFindingAddressOfUser = false.obs;
  Rx<String> userAddress = ''.obs;
  Rx<String> userCountry = ''.obs;
  Rx<String> userState = ''.obs;
  Rx<String> userCity = ''.obs;
  Rx<String> userName = ''.obs;
  Rx<String> userEmail = ''.obs;
  Rx<String> userPhone = ''.obs;
  Rx<String> usereEnterpriseName = ''.obs;
  RxString userType = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    userType.value = await getStorage.read('initialPayment') as String;
    log(userType.value);
    loadData();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  String? nameValidator(String? value) => GetUtils.isLengthLessOrEqual(value, 3)
      ? 'Please enter a valid name'
      : null;

  String? emailValidator(String? value) =>
      GetUtils.isEmail(value!) ? null : 'Please enter a valid email';

  String? phoneNumberValidator(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 9)
          ? 'Please enter a valid phone number'
          : null;

  String? addressValidator(String? value) =>
      GetUtils.isLengthGreaterOrEqual(value, 10)
          ? null
          : 'please enter a valid address';

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    user.value = await getCurrentUserDetails();
    user.value.paymentStatus != '' && user.value.paymentStatus != null
        ? await getStorage.write('initialPayment', 'paid')
        : await getStorage.write('initialPayment', '');
    userEmail.value = user.value.email.toString();
    usereEnterpriseName.value = user.value.enterpriseName.toString();
    selectedGender.value = user.value.gender != ''
        ? Gender.values.firstWhere(
            (Gender gender) =>
                gender.toString().split('.').last.toLowerCase() ==
                user.value.gender?.toLowerCase(),
            orElse: () => Gender.Male,
          )
        : Gender.Male;
    // selectedCategoryType.value =
    //     categoryTypeMap[user.value.category] ?? CategoryType.standard;
    selectedCategoryType.value = user.value.category != ''
        ? CategoryType.values.firstWhere(
            (CategoryType categoryType) =>
                categoryType.toString().split('.').last.toLowerCase() ==
                user.value.category?.toLowerCase(),
            orElse: () => CategoryType.standard,
          )
        : CategoryType.standard;
    userPhone.value = user.value.phoneNumber.toString();
    userName.value = user.value.name.toString();
    userAddress.value = user.value.address.toString();
    userCity.value = user.value.district.toString();
    userCountry.value = user.value.country.toString();
    userState.value = user.value.state.toString();
    change(null, status: RxStatus.success());
  }

  Future<UserModel> getCurrentUserDetails() async {
    final ApiResponse<UserModel> response =
        await UserRepository().getUserDetails();
    if (response.data != null) {
      return response.data!;
    }
    return response.data!;
  }

  Future<void> getAddressofUser() async {
    isFindingAddressOfUser.value = true;
    final Position position = await getGeoLocationPosition();
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark place = placemarks[0];
    userAddress.value =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    userState.value = place.administrativeArea.toString();
    userCountry.value = place.country.toString();
    userCity.value = place.locality.toString();
    isFindingAddressOfUser.value = false;
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future<Position>.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future<Position>.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future<Position>.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> onRegisterClicked() async {
    if (formKey.currentState!.validate()) {
      isloading.value = true;
      if (userType.value == 'paid' ||
          selectedCategoryType.value == CategoryType.standard) {
        await saveUserInfo();
        isloading.value = false;
      } else {
        await CustomDialog().showCustomDialog(
            'Register as premium user of TourMaker',
            contentText:
                'You have to pay \n424+GST \nto apply as an\n premium user of TourMaker',
            cancelText: 'Go Back',
            confirmText: 'Pay rs 424 + GST', onCancel: () {
          selectedCategoryType.value = CategoryType.standard;
          Get.back();
          isloading.value = false;
        }, onConfirm: () async {
          Get.back();
          await payAmount();
          isloading.value = false;
        });
      }
    }
  }

  Future<void> payAmount() async {
    isloading.value = true;
    if (formKey.currentState!.validate()) {
      final RazorPayModel razorPaymodel = RazorPayModel(
        contact: userPhone.value,
        currency: 'INR',
        name: userName.value,
      );
      final ApiResponse<RazorPayModel> res =
          await RazorPayRepository().createPayment(razorPaymodel);
      try {
        if (res.data != null) {
          razorPayModel.value = res.data!;
          await openRazorPay(razorPayModel.value.packageId.toString());
        } else {}
        isloading.value = false;
      } catch (e) {
        CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      }
    } else {
      isloading.value = false;
    }
  }

  Future<void> openRazorPay(String orderId) async {
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_live_VpG0vgAvsBqlnU',
      'name': 'Tour Maker',
      'description': 'Register as premium customer of Tour Maker ',
      'order_id': orderId,
      'prefill': <String, Object?>{
        'contact': userPhone.value,
      },
      'external': <String, Object?>{
        'wallets': <String>[
          'paytm',
          'freecharge',
          'mobikwik',
          'jiomoney',
          'airtelmoney',
          'payzapp',
          'olamoney',
          'phonepe',
          'amazonpay',
          'googlepay'
        ],
      },
    };

    try {
      razorPay.open(options);
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final String? signature = response.signature;
    final String? orderId = razorPayModel.value.packageId;
    final String? paymentId = response.paymentId;
    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyInitialPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed) {
        isPaidInitial.value = true;
        await getStorage.write('initialPayment', 'paid');
        userType.value = 'paid';
      } else {
        userType.value = '';
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      userType.value = '';
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) =>
      CustomDialog().showCustomDialog('Payment error: ${response.code}',
          contentText: '${response.message}');

  void _handleExternalWallet(ExternalWalletResponse response) => Get.snackbar(
        'Payment successed: ',
        'on : ${response.walletName}',
        backgroundColor: englishViolet,
        colorText: Colors.white,
      );

  Future<void> saveUserInfo() async {
    isloading.value = true;
    if (formKey.currentState!.validate()) {
      final String categoryOFuser = selectedCategoryType.value
          .toString()
          .split('.')
          .last
          .split('_')
          .join(' ');
      final String districtOFuser = userCity.value;
      final String emailOFuser = userEmail.value;
      final String genderOFuser =
          selectedGender.value.toString().split('.').last.split('_').join(' ');
      final String nameOFuser = userName.value;
      final String stateOFuser = userState.value;
      final String phoneNumberOfuser = userPhone.value;
      final String addressOFuser = userAddress.value;
      final String enterpriseNameOFuser = usereEnterpriseName.value;
      final String countryOFuser = userCountry.value;

      try {
        await updateUser(
          categoryOFuser: categoryOFuser,
          countryOFuser: countryOFuser,
          districtOFuser: districtOFuser,
          emailOFuser: emailOFuser,
          genderOFuser: genderOFuser,
          nameOFuser: nameOFuser,
          stateOFuser: stateOFuser,
          phoneNumberOfuser: phoneNumberOfuser,
          addressOFuser: addressOFuser,
          enterpriseNameOFuser: enterpriseNameOFuser,
        );
        isloading.value = false;
      } catch (e) {
        CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      }
    } else {
      isloading.value = false;
    }
  }

  Future<void> updateUser({
    String? categoryOFuser,
    String? districtOFuser,
    String? emailOFuser,
    String? genderOFuser,
    String? nameOFuser,
    String? stateOFuser,
    String? phoneNumberOfuser,
    String? addressOFuser,
    String? enterpriseNameOFuser,
    String? countryOFuser,
  }) async {
    final ApiResponse<Map<String, dynamic>> res =
        await UserRepository().updateUser(
      categoryOFuser: categoryOFuser,
      districtOFuser: districtOFuser,
      emailOFuser: emailOFuser,
      genderOFuser: genderOFuser,
      nameOFuser: nameOFuser,
      countryOFuser: countryOFuser,
      stateOFuser: stateOFuser,
      phoneNumberOfuser: phoneNumberOfuser,
      addressOFuser: addressOFuser,
      enterpriseNameOFuser: enterpriseNameOFuser,
    );
    try {
      if (res.status == ApiResponseStatus.completed) {
        await getStorage.write('currentUserAddress', addressOFuser);
        await getStorage.write('currentUserCategory', categoryOFuser);
        await getStorage.write('currentUserName', nameOFuser);
        await getStorage.write('currentUserCountry', countryOFuser);
        await getStorage.write('currentUserDistrict', districtOFuser);
        await getStorage.write('currentUserEmail', emailOFuser);
        await getStorage.write(
            'currentUserEnterpriseName', enterpriseNameOFuser);
        await getStorage.write('currentUserGender', genderOFuser);
        await getStorage.write('currentUserPhoneNumber', phoneNumberOfuser);
        await getStorage.write('currentUserState', stateOFuser);
        isloading.value = false;
        Get.back();
      } else {
        isloading.value = false;
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }
}
