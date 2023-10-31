import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/network_models/order_payment_model.dart';
import '../../../data/models/network_models/single_booking_model.dart';
import '../../../data/repo/network_repo/booking_repo.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/booking_summary_view.dart';

class BookingSummaryController extends GetxController
    with StateMixin<BookingSummaryView> {
  RxList<SingleBookingModel> bookingList = <SingleBookingModel>[].obs;
  Rx<bool> isLoading = false.obs;
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  late Razorpay razorPay;
  int? id;
  @override
  void onInit() {
    super.onInit();
    loadData();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void loadData() {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      id = Get.arguments as int;
      loadBookingDetails(id!);
    }
  }

  Future<void> loadBookingDetails(int id) async {
    final ApiResponse<List<SingleBookingModel>> res =
        await BookingRepository().getSingleTourBooking(id);
    if (res.data != null) {
      bookingList.value = res.data!;
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  int getTotalTravellersCount() {
    final int sum = bookingList[0].noOfAdults! + bookingList[0].noOfKids!;
    return sum;
  }

  num getRemainingAmount() {
    final num sum = bookingList[0].payableAmount! - bookingList[0].amountPaid!;
    return sum;
  }

  void onClickPassengers(int? id) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: id)!
        .whenComplete(() => loadData());
  }

  num getPackageGSTamount(num totalAmount, num gst) {
    final num gstAmount = (totalAmount * gst) / 100;
    return gstAmount;
  }

  Future<void> onClickPayRemainingAmount(int id) async {
    orderPaymentModel.value = await createPayment(id);
    if (orderPaymentModel.value != null) {
      log(orderPaymentModel.value.id.toString());
      openRazorPay(orderPaymentModel.value.id.toString());
    } else {
      CustomDialog().showCustomDialog('Payment Error',
          contentText: 'Sorry we cannot make the payment');
    }
  }

  Future<OrderPaymentModel> createPayment(int iD) async {
    final OrderPaymentModel omp =
        OrderPaymentModel(orderId: iD, currency: 'INR');

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createRemainingAmountPayment(omp);
      if (res.data != null) {
        orderPaymentModel.value = res.data!;
      } else {
        CustomDialog().showCustomDialog('Payment Error',
            contentText: 'Sorry we cannot make the payment');
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
    return orderPaymentModel.value;
  }

  void openRazorPay(String paymentID) {
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_live_VpG0vgAvsBqlnU',
      'name': 'TourMaker',
      'description': 'Pay for your Package Order',
      'order_id': paymentID,
      'external': <String, Object?>{
        'wallets': <String>['paytm'],
      },
    };
    try {
      log(options.toString());
      razorPay.open(options);
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final String? signature = response.signature;
    final String? orderId = orderPaymentModel.value.id;
    final String? paymentId = response.paymentId;
    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyOrderPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed && res.data!) {
        Get.offAllNamed(Routes.HOME)!.then(
          (dynamic value) => Get.snackbar(
            'Success ',
            'Payment Suucess for the tour ${bookingList[0].tourName}',
            backgroundColor: englishViolet,
            colorText: Colors.white,
          ),
        );
      } else {}
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomDialog().showCustomDialog('Payment error: ${response.code}',
        contentText: '${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomDialog().showCustomDialog('Payment successed: ',
        contentText: 'on : ${response.walletName}');
  }
}
