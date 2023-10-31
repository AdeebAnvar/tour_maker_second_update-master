import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/theme/style.dart';
import '../../../main.dart';
import '../../data/repo/network_repo/user_repo.dart';
import '../../routes/app_pages.dart';
import '../../widgets/custom_dialogue.dart';
import '../network_services/dio_client.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

final GetStorage storage = GetStorage();
Future<void> sendPhoneNumberToFirebase(
    {required String phoneNumber, bool? isLoading}) async {
  await auth
      .verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: const Duration(seconds: 60),
    verificationCompleted: (PhoneAuthCredential authCredential) async {},
    verificationFailed: (FirebaseAuthException e) {
      isLoading = false;
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
          'Phone number $phoneNumber verification failed.',
          contentText: errorMessage,
          confirmText: 'Retry', onConfirm: () {
        isLoading = false;
        Get.offAllNamed(Routes.GET_STARTED);
      });
    },
    codeSent: (String verificationId, [int? forceResendingToken]) async {
      await Get.toNamed(Routes.OTP_SCREEN, arguments: <dynamic>[
        verificationId,
        phoneNumber,
        forceResendingToken
      ]);
      isLoading = false;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  )
      .catchError((dynamic e) {
    log('firefunction $e ');
    isLoading = false;
  });
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
        const DarwinInitializationSettings ios = DarwinInitializationSettings();
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
        Get.offAllNamed(Routes.MAIN_SCREEN);
        // CustomDialog().showCustomDialog(notification.title!,
        //     contentText: notification.body);
      }
    },
  );

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  final NotificationSettings settings = await messaging.requestPermission();

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

String? getUserPhoneNumber() => auth.currentUser!.phoneNumber;
Future<void> gustUserLogin(
    {required String phoneNumber, required bool isloading}) async {
  isloading = true;

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential verificationId) {
      log('Verification ID: $verificationId');
    },
    verificationFailed: (FirebaseAuthException error) {
      log('Verification failed: $error');
    },
    codeSent: (String verificationId, int? forceResendingToken) async {
      log('Code sent: $verificationId');
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: '123456',
          ),
        );
        final User user = userCredential.user!;
        if (user.uid != null) {
          final IdTokenResult idTokenResult = await user.getIdTokenResult(true);
          final String token = idTokenResult.token!;
          await storage.write('token', token).then(
                (dynamic value) async =>
                    storage.write('user-type', 'demo').whenComplete(
                          () => Get.toNamed(Routes.HOME),
                        ),
              );
        }
        log('Signed in');
      } catch (error) {
        log('Error signing in: $error');
      }
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      log('Code auto retrieval timed out: $verificationId');
    },
  );

  isloading = false;
}

Future<void> otpVerification(
    {required String otpCode,
    required String verID,
    required Future<void> checkUser}) async {
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verID,
      smsCode: otpCode,
    );
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    final User user = userCredential.user!;
    if (user.uid != null) {
      final IdTokenResult idTokenResult = await user.getIdTokenResult(true);
      final String token = idTokenResult.token!;
      await storage.write('token', token).then((dynamic e) async => checkUser);
    }
    log('kunukun fire otp code $otpCode');
    log('kunukun fire verid $verID');
    log('kunukun fire credent $userCredential');
    log('kunukun fire tok ${user.getIdToken()}');
    log('kunukun fire credent $checkUser');
  } catch (e) {
    log('firebase OTP catcge $e');
  }
}

Future<void> resendOTP({required String phone}) async {
  void verificationCompleted(AuthCredential phoneAuthCredential) {}
  void verificationFailed(FirebaseAuthException exception) {}
  Future<void> codeSent(String verificationId,
      [int? forceResendingToken]) async {
    final String verificationid = verificationId;
    Get.toNamed(
      Routes.OTP_SCREEN,
      arguments: <dynamic>[
        verificationid,
        phone,
      ],
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {}
  await auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 60),
    verificationCompleted: verificationCompleted,
    verificationFailed: verificationFailed,
    codeSent: codeSent,
    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  );
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<void> initNotifications() async {
  await _firebaseMessaging.requestPermission();
  final String? fcmToken = await _firebaseMessaging.getToken();
  log(fcmToken.toString());
}
