import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/login_view.dart';

class LoginController extends GetxController with StateMixin<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey();
  UserRepository userRepo = UserRepository();
  // late List<String> states = userRepo.getStates();
  Rx<String> userState = ''.obs;
  final GetStorage getStorage = GetStorage();
  // RxString state = ''.obs;
  RxString name = ''.obs;
  RxString phone = ''.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    loadUserCredentials();
    // await getAddressofUser();
    change(null, status: RxStatus.success());
  }

  String? usernameValidator(String? value) =>
      GetUtils.isLengthLessThan(value, 4) ? 'Please enter your name' : null;

  Future<void> onClickContinue(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      final UserModel user = UserModel(
        name: name.value,
        state: userState.value,
        category: 'standard',
      );
      await getStorage.write('currentUserCategory', 'standard');
      await getStorage.write('currentUserName', name.value);
      await getStorage.write('currentUserState', user.state);
      await getStorage.write('initialPayment', '');
      await getStorage.write('currentUserAddress', '');
      await getStorage.write('newUser', 'true');
      final ApiResponse<Map<String, dynamic>> res =
          await userRepo.loginTheUser(user);
      if (res.status == ApiResponseStatus.completed) {
        Get.offAllNamed(Routes.TERMS_AND_CONDITIONS);
        isLoading.value = false;
      } else {}
    }
  }

  void loadUserCredentials() {
    if (Get.arguments != null) {
      phone.value = Get.arguments as String;
    }
  }

  Future<void> getAddressofUser() async {
    final Position position = await getGeoLocationPosition();
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark place = placemarks[0];
    userState.value = place.administrativeArea.toString();
    log(userState.value);
    change(null, status: RxStatus.success());
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

  String? validateState(String? value) =>
      GetUtils.isBlank(value) != true ? null : 'Please add state';
}
