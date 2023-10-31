import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'package:sms_autofill/sms_autofill.dart';

import 'package:timer_count_down/timer_controller.dart';
import '../../../../core/theme/style.dart';

import '../../../../main.dart';
import '../../../data/models/network_models/user_model.dart';

import '../../../data/repo/network_repo/user_repo.dart';

import '../../../routes/app_pages.dart';

import '../../../services/custom_functions/firebase_functions.dart' as firebase;

import '../../../services/network_services/dio_client.dart';

import '../../../widgets/custom_dialogue.dart';

import '../views/otp_screen_view.dart';

class OtpScreenController extends GetxController
    with StateMixin<OtpScreenView> {
  CountdownController countDownController = CountdownController();

  TextEditingController textEditorController = TextEditingController();

  GetStorage getStorage = GetStorage();

  String? phone;

  String? verID;

  RxBool isLoading = false.obs;

  RxString otpCode = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loadData();

    await SmsAutoFill().listenForCode();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    countDownController.start();
  }

  @override
  Future<void> onClose() async {
    super.onClose();

    SmsAutoFill().unregisterListener();

    textEditorController.dispose();
  }

  void loadData() {
    change(null, status: RxStatus.loading());

    if (Get.arguments != null) {
      verID = Get.arguments[0] as String;

      phone = Get.arguments[1] as String;
    }

    change(null, status: RxStatus.success());
  }

  Future<void> signIn() async {
    isLoading.value = true;

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verID.toString(),
        smsCode: otpCode.toString(),
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      if (user.uid != null) {
        final IdTokenResult idTokenResult = await user.getIdTokenResult(true);
        final String token = idTokenResult.token!;
        await getStorage.write('token', token);
        await checkUserExistsORnot();
      }
    } catch (e) {
      await CustomDialog().showCustomDialog(
        'OOPS...!',
        contentText: 'You entered the wrong OTP!!',
        confirmText: 'Get OTP',
        cancelText: 'Change number',
        onConfirm: () {
          Get.back();
          onResendinOTP();
        },
        onCancel: () {
          Get.back();

          Get.offAllNamed(Routes.GET_STARTED);
        },
      );
      isLoading.value = false;
    }
  }

  Future<void> onResendinOTP() async {
    change(null, status: RxStatus.loading());
    countDownController.restart();
    final FirebaseAuth auth = FirebaseAuth.instance;
    void verificationCompleted(AuthCredential phoneAuthCredential) {}
    void verificationFailed(FirebaseAuthException e) {
      String errorMessage = 'An error occurred during phone verification.';

      if (e.code == 'invalid-phone-number') {
        errorMessage =
            'Invalid phone number. Please enter a valid phone number.';
      } else if (e.code == 'network-request-failed') {
        errorMessage =
            'Network error. Please check your internet connection and try again.';
      }
      CustomDialog().showCustomDialog(
          barrierDismissible: false,
          'Phone number verification failed.',
          contentText: errorMessage,
          confirmText: 'Retry', onConfirm: () {
        isLoading.value = false;
        Get.offAllNamed(Routes.GET_STARTED);
      });
    }

    Future<void> codeSent(String verificationId,
        [int? forceResendingToken]) async {
      final String verificationid = verificationId;
      Get.toNamed(
        Routes.OTP_SCREEN,
        arguments: <dynamic>[
          verificationid,
          phone.toString(),
        ],
      );
      change(null, status: RxStatus.success());
    }

    void codeAutoRetrievalTimeout(String verificationId) {}
    await auth.verifyPhoneNumber(
      phoneNumber: phone.toString(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    textEditorController.text = '';
    change(null, status: RxStatus.success());
  }

  Future<void> checkUserExistsORnot() async {
    isLoading.value = true;
    try {
      final ApiResponse<UserModel> res =
          await UserRepository().getUserDetails();

      if (res.status == ApiResponseStatus.completed) {
        final UserModel user = res.data!;

        if (user.phoneNumber == phone) {
          await firebase.notificationPermissionwithPutMethod();

          await getStorage.write('currentUserAddress', user.address);

          await getStorage.write('currentUserCategory', user.category);

          await getStorage.write('newUser', 'false');
          await getStorage.write('customer_Id', user.customerId);
          user.paymentStatus != '' && user.paymentStatus != null
              ? await getStorage.write('initialPayment', 'paid')
              : await getStorage.write('initialPayment', '');
          await getStorage.write('user-type', 'real');

          await getStorage.write('userName', user.name);

          await getStorage.write('userPhone', user.phoneNumber);
          await notificationPermissionwithPutMethod();
          await Get.offAllNamed(Routes.HOME);

          isLoading.value = false;
        } else {
          await notificationPermissionwithPostMethod();

          Get.offAllNamed(Routes.LOGIN, arguments: phone);

          isLoading.value = false;
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> notificationPermissionwithPutMethod() async {
    log('message 5');

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final RemoteNotification? notification = message.notification;

        final AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: englishViolet,
                  icon: '@drawable/ic_launcher',
                ),
              ),
              payload: jsonEncode(message.toMap()));
          const DarwinInitializationSettings ios =
              DarwinInitializationSettings();
          const AndroidInitializationSettings android =
              AndroidInitializationSettings('@drawable/ic_launcher');
          const InitializationSettings initializationSettings =
              InitializationSettings(android: android, iOS: ios);
          flutterLocalNotificationsPlugin.initialize(
            initializationSettings,
          );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        log('A new onMessageOpenedApp event was published!');

        final RemoteNotification? notification = message.notification;

        final AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          CustomDialog().showCustomDialog(notification.title!,
              contentText: notification.body);
        }
      },
    );

    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final NotificationSettings settings = await messaging.requestPermission();
    final GetStorage storage = GetStorage();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await storage.write('isNotificationON', 'true');

      final String? fcmToken = await messaging.getToken();

      messaging.onTokenRefresh;

      log(fcmToken!);

      final ApiResponse<Map<String, dynamic>> res =
          await UserRepository().putFCMToken(fcmToken);

      log('message ${res.message}');

      if (res.status == ApiResponseStatus.completed) {}
    } else {
      await storage.write('isNotificationON', 'false');
    }
  }

  Future<void> notificationPermissionwithPostMethod() async {
    log('message 5');
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final NotificationSettings settings = await messaging.requestPermission();
      final GetStorage storage = GetStorage();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await storage.write('isNotificationON', 'true');

        final String? fcmToken = await messaging.getToken();

        log(fcmToken!);

        final ApiResponse<Map<String, dynamic>> res =
            await UserRepository().postFCMToken(fcmToken);

        log('message ${res.message}');

        if (res.status == ApiResponseStatus.completed) {
          await storage.write('isNotificationON', 'true');
        }
      } else {
        await storage.write('isNotificationON', 'false');
      }
    } catch (e) {
      log('iuugui $e');
    }
  }
}
