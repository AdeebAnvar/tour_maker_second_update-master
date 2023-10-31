import 'dart:async';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../app/services/custom_functions/firebase_functions.dart'
    as firebase;

import '../../../data/models/network_models/user_model.dart';

import '../../../data/repo/network_repo/user_repo.dart';

import '../../../routes/app_pages.dart';

import '../../../services/network_services/dio_client.dart';

import '../../../widgets/custom_dialogue.dart';

class SplashScreenController extends GetxController with StateMixin<dynamic> {
  final GetStorage getStorage = GetStorage();

  Rx<bool> isInternetConnect = true.obs;
  List<int> allPackages = <int>[];
  @override
  Future<void> onInit() async {
    super.onInit();

    await getStorage.write('user-type', 'real');

    await isInternetConnectFunction();

    log('message 1');
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    log('message 2');

    await checkUserLoggedInORnOT();
  }

  Future<void> isInternetConnectFunction() async {
    log('message 3');

    isInternetConnect.value = await InternetConnectionChecker().hasConnection;

    isInternetConnect.value != true
        ? await Get.toNamed(Routes.NOINTERNET)
        : await checkUserLoggedInORnOT();
  }

  Future<void> checkUserLoggedInORnOT() async {
    final User? currentUser = firebase.auth.currentUser;
    // final List<PackageModel> packageData = <PackageModel>[];
    log('jujhuhkik');
    // if (packageData.isEmpty || packageData == null) {
    //   log('jujhuhjk');
    //   for (int i = 1; packageData.length <= 9; i++) {
    //     getAllPackages(i);
    //     log('jujhuh');
    //   }
    // }

    // if (getStorage.hasData('packageData')) {
    //   // allPackages = getStorage.read('packageData') as List<PackageModel>;
    //   log('jiuiuriugr');
    // } else {
    //   log('jiuiuriugrgwrr');
    //   await fetchAndStoreAllPackages();
    // }
    try {
      if (currentUser != null) {
        final String? token = await currentUser.getIdToken(true);

        await getStorage.write('token', token);

        // log(token);

        await firebase.notificationPermissionwithPutMethod();

        await checkUserExistsOnDB();
      } else {
        await Get.offAllNamed(Routes.GET_STARTED);
      }
    } catch (e) {
      await CustomDialog()
          .showCustomDialog('Error !', contentText: e.toString());
    }
  }

  Future<void> checkUserExistsOnDB() async {
    final ApiResponse<UserModel> res = await UserRepository().getUserDetails();
    if (res.data != null && res.data!.phoneNumber != '') {
      final UserModel user = res.data!;
      if (user.tAndCStatus == 'true') {
        await getStorage.write('currentUserAddress', user.address);
        await getStorage.write('currentUserCategory', user.category);
        await getStorage.write('customer_Id', user.customerId);
        await getStorage.write('newUser', 'false');
        await getStorage.write('userName', user.name);
        await getStorage.write('userPhone', user.phoneNumber);
        user.paymentStatus != '' && user.paymentStatus != null
            ? await getStorage.write('initialPayment', 'paid')
            : await getStorage.write('initialPayment', '');
        await Get.offAllNamed(Routes.HOME);
      } else {
        await getStorage.write('newUser', 'true');
        Get.offAllNamed(Routes.TERMS_AND_CONDITIONS);
      }
    } else {
      await firebase.notificationPermissionwithPostMethod();
      final String? phoneNumber = firebase.getUserPhoneNumber();
      await Get.offAllNamed(Routes.LOGIN, arguments: phoneNumber);
    }
  }
}
