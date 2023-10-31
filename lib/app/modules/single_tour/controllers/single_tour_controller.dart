// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/local_model/checkout_model.dart';
import '../../../data/models/network_models/custom_enquiry_model.dart';
import '../../../data/models/network_models/order_model.dart';
import '../../../data/models/network_models/single_tour_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/local_repo/checkout_repo.dart';
import '../../../data/repo/network_repo/booking_repo.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/singletourrepo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/single_tour_view.dart';

class SingleTourController extends GetxController
    with StateMixin<SingleTourView> {
  TextEditingController textFieldController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  final GetStorage getStorage = GetStorage();
  late int totalAmount;
  final RxInt selectedBatchTourIndex = 0.obs;
  Rx<SingleTourModel> batchTour = SingleTourModel().obs;
  RxList<PackageData> batchTourPackageDatesRX = <PackageData>[].obs;
  RxString tourDate = ''.obs;
  RxString tourRequirements = ''.obs;
  RxList<WishListModel> wishlists = <WishListModel>[].obs;
  Rx<int> selectedTabIndex = 0.obs;
  Rx<int> adult = 1.obs;
  Rx<int> children = 0.obs;
  Rx<bool> isloading = false.obs;
  Rx<bool> isloadingTheViewItinerraryButton = false.obs;
  Rx<bool> isloadingEnquiryButton = false.obs;
  Rx<bool> isFavourite = false.obs;
  bool isLoading = false;
  RxBool hasReachedEndofBatchTours = false.obs;
  int? tourID;
  int? order;
  int batchToursDatesPage = 1;
  int individualToursDatesPage = 1;
  String? userName;
  String? userPhone;
  String? currentUserAddress;
  String? userType;
  String? customerId;

  String? currentUserCategory;
  @override
  Future<void> onInit() async {
    super.onInit();
    await loadDatas();
    userType = await getStorage.read('user-type') as String;
    userName = await getStorage.read('userName') as String;
    userPhone = await getStorage.read('userPhone') as String;
    customerId = await getStorage.read('customer_Id') as String;
  }

  Future<void> loadDatas() async {
    change(null, status: RxStatus.loading());

    await fetchData();
    change(null, status: RxStatus.success());
  }

  Future<void> fetchData() async {
    log('message');
    if (batchTourPackageDatesRX.isNotEmpty) {
      batchTourPackageDatesRX.value = <PackageData>[];
    }
    await datasFromLocalStorage();
    try {
      final int id = await loadData();
      await loadFixedTourData(id);
      await loadWishLists(id);
    } catch (er) {
      CustomDialog()
          .showCustomDialog('Error dff !', contentText: er.toString());
    }
  }

  Future<int> loadData() async {
    if (Get.arguments != null) {
      tourID = Get.arguments[0] as int;
      return tourID!;
    }
    return tourID!;
  }

  Future<void> loadFixedTourData(int tourID, {int page = 1}) async {
    try {
      final ApiResponse<SingleTourModel> res =
          await SingleTourRepository().getSingleTour(tourID, page);
      if (res.data != null) {
        final SingleTourModel data = res.data!;
        batchTour.value = res.data!;
        final List<PackageData> newData = data.packageData!;
        if (newData.isNotEmpty) {
          batchTourPackageDatesRX.addAll(newData.toList());
          batchToursDatesPage = page;
          if (newData.length < 10) {
            hasReachedEndofBatchTours.value = true;
          }
          log('message1');
        } else {
          log('message2');
          // hasReachedEnd.value = true;
          // Empty response, indicating the end of data
        }
      } else {
        throw Exception('Failed to load single tour data: empty response');
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch single tour data for tour ID $tourID: $e');
    }
  }

  Future<List<WishListModel>?> getWishList(int id) async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.status == ApiResponseStatus.completed) {
      if (res.data != null) {
        final List<WishListModel> wishListData =
            res.data! as List<WishListModel>;
        return wishListData;
      }
      return null;
    } else {
      throw Exception('Failed to load wishlist data');
    }
  }

  Future<void> onViewItineraryClicked(String itinerary, String tourCode) async {
    isloadingTheViewItinerraryButton.value = true;
    await downloadPdf(itineraryLink: itinerary, tourCode: tourCode);
    //
    isloadingTheViewItinerraryButton.value = false;
  }

  Future<void> downloadPdf(
      {required String itineraryLink, required String tourCode}) async {
    try {
      log('fucking uyu message');
      final http.Response response = await http.get(Uri.parse(itineraryLink));
      final Uint8List bytes = response.bodyBytes;

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$tourCode.pdf');
      file.open();
      await file.writeAsBytes(bytes).then((File value) => Get.toNamed(
          Routes.PDF_VIEW,
          arguments: <String>[file.path, tourCode, itineraryLink]));
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      isloadingTheViewItinerraryButton.value = false;
    }
  }

  void onClickAdultSubtract() {
    if (adult.value > 1) {
      adult.value--;
    }
  }

  void onClickAdultAdd() {
    adult.value++;
  }

  void onClickSubtractChildren() {
    if (children.value > 0) {
      children.value--;
    }
  }

  void onClickAddChildren() {
    children.value++;
  }

  Future<void> onClickAddBatchTourPassenger(PackageData package) async {
    if (userType == 'demo') {
      CustomDialog().showCustomDialog(
        'You need to log in again',
        cancelText: 'Go Back',
        confirmText: 'Ok',
        onCancel: () => Get.back(),
        onConfirm: () async {
          await logoutUser();
        },
      );
    } else {
      if (currentUserAddress != null && currentUserAddress != '') {
        final DateTime selectedDate =
            DateTime.parse(package.dateOfTravel.toString());
        final DateTime today = DateTime.now();
        if (package.availableSeats == 0) {
          CustomDialog().showCustomDialog(
            'Seats Filled!!',
            contentText:
                "Sorry the seat's are filled in this tour .  we will reach out you soon when the seats are available",
          );
        } else {
          if (selectedDate.difference(today).inDays <= 7) {
            await showWarningDialogue(package);
          } else {
            await confirmPayment(package.iD!, package);
          }
        }
      } else {
        await Get.toNamed(Routes.USER_REGISTERSCREEN)!
            .whenComplete(() => fetchData());
      }
    }
  }

  Future<int?> createUserOrder(int packageID, PackageData package) async {
    final OrderModel om = OrderModel(
      noOfAdults: adult.value,
      noOfChildren: children.value,
      packageID: packageID,
    );
    final ApiResponse<dynamic> resp = await PassengerRepository().addOrder(om);
    if (resp.data != null) {
      order = resp.data as int;
      return order!;
    } else {}
    return order;
  }

  Future<void> onClickAddToFavourites() async {
    try {
      if (isFavourite.value == true) {
        await _deleteFromFav();
      } else {
        await _addToFav();
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  int getTotalAmountOFtour(
      int adultCount, int childcount, PackageData packageData, int index) {
    int adultAmount;
    int childAmount;
    packageData.offerAmount == 0
        ? adultAmount = packageData.amount!
        : adultAmount = packageData.offerAmount!;
    packageData.kidsOfferAmount != 0
        ? childAmount = packageData.kidsOfferAmount!
        : childAmount = packageData.kidsAmount!;
    final int totalAdultAmount = adultCount * adultAmount;
    final int totalChildrensAmount = childcount * childAmount;
    totalAmount = totalAdultAmount + totalChildrensAmount;

    return totalAmount;
  }

  Future<void> onCallClicked() async {
    final Uri url = Uri.parse('tel:914872383104');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomDialog().showCustomDialog('Error !',
          contentText: "couldn't dial to 4872383104");
    }
  }

  Future<void> onWhatsAppClicked() async {
    const String phone = '+919995538909';
    final String message = '''
Hi
            i am $userName
          Customer ID :  $customerId
            I need to know more about the ${batchTour.value.tourData!.name} (${batchTour.value.tourData!.tourCode}) ''';
    final String url = 'https://wa.me/$phone?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not launch WhatsApp');
    }
  }

  Future<void> confirmPayment(int packageID, PackageData packageData) async {
    isloading.value = true;
    order = await createUserOrder(packageID, packageData);
    if (order != null) {
      final CheckOutModel cm = CheckOutModel(
        adultCount: adult.value,
        amount: packageData.amount,
        childrenCount: children.value,
        commission: packageData.agentCommission,
        dateOfTravel: packageData.dateOfTravel,
        gst: packageData.gstPercent,
        tourID: batchTour.value.tourData?.iD,
        kidsAmount: packageData.kidsAmount,
        kidsOfferAmount: packageData.kidsOfferAmount,
        offerAmount: packageData.offerAmount,
        orderID: order,
        tourCode: batchTour.value.tourData?.tourCode,
        tourItinerary: batchTour.value.tourData?.itinerary,
        tourName: batchTour.value.tourData?.name,
        transportationMode: packageData.transportationMode,
        advanceAmount: packageData.advanceAmount,
      );
      try {
        await CheckOutRepositoy.saveData(cm);
      } catch (e) {
        CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      }
      final int passengers = totaltravellers();
      Get.toNamed(Routes.ADD_PASSENGER,
          arguments: <dynamic>[order, passengers]);
    } else {
      CustomDialog().showCustomDialog(
        'Exceeded the Seat Limit',
        contentText: 'Please check the seats available',
      );
    }
    isloading.value = false;
  }

  int totaltravellers() {
    final int sum = adult.value + children.value;
    return sum;
  }

  Future<void> datasFromLocalStorage() async {
    currentUserAddress = await getStorage.read('currentUserAddress') as String;
    currentUserCategory =
        await getStorage.read('currentUserCategory') as String;
    log('Adeeb $currentUserAddress');
    log('Adeeb $currentUserCategory');
  }

  Future<void> loadWishLists(int id) async {
    final List<WishListModel>? wishlistData = await getWishList(id);
    if (wishlistData != null) {
      wishlists.value = wishlistData;

      for (final WishListModel wm in wishlists) {
        if (wm.id == id) {
          isFavourite.value = true;
          break;
        } else {
          isFavourite.value = false;
        }
      }
    }
  }

  Future<void> showWarningDialogue(PackageData package) async {
    await CustomDialog().showCustomDialog('Warning ! !',
        contentText:
            'The selected date is very near \nso you need to pay full amount and\n you have to contact and confirm the tour',
        onConfirm: () async {
      Get.back();
      await confirmPayment(package.iD!, package);
    }, onCancel: () async {
      Get.back();
    }, confirmText: 'OK', cancelText: 'back');
  }

  Future<void> _deleteFromFav() async {
    try {
      final ApiResponse<Map<String, dynamic>> res =
          await WishListRepo().deleteFav(batchTour.value.tourData?.iD);
      if (res.status == ApiResponseStatus.completed) {
        isFavourite.value = false;
      }
    } catch (e) {
      CustomDialog().showCustomDialog("Can't Delete From favourites",
          contentText: e.toString());
    }
  }

  Future<void> _addToFav() async {
    try {
      final ApiResponse<Map<String, dynamic>> res =
          await WishListRepo().createFav(batchTour.value.tourData?.iD);
      if (res.status == ApiResponseStatus.completed) {
        isFavourite.value = true;
      }
    } catch (e) {
      CustomDialog()
          .showCustomDialog("Can't Add to fav", contentText: e.toString());
    }
  }

  void loadMoreFixedTours() {
    final int nextPage = batchToursDatesPage + 1;
    loadFixedTourData(tourID!, page: nextPage);
  }

  String? tourDateValidator(String? value) =>
      DateTime.tryParse(value ?? '') != null ? null : 'Please select a date';

  String? validateRequirements(String? value) =>
      GetUtils.isLengthLessOrEqual(value, 5) ? 'Requirements not met' : null;

  Future<void> onClickEnquiry() async {
    isloadingEnquiryButton.value = true;
    if (formKey.currentState!.validate()) {
      log('sdgerfvsc ${tourRequirements.value}');
      final CustomEnquiryModel cm = CustomEnquiryModel(
        tourId: batchTour.value.tourData!.iD,
        dateOfTravel: tourDate.value,
        noOfAdults: adult.value,
        noOfKids: children.value,
        otherRequirements: tourRequirements.value,
      );
      await sendCustomEnquiry(cm);
      isloadingEnquiryButton.value = false;
    } else {
      isloadingEnquiryButton.value = false;
    }
  }

  Future<void> sendCustomEnquiry(CustomEnquiryModel cm) async {
    if (userType == 'demo') {
      CustomDialog().showCustomDialog(
        'You need to log in again',
        cancelText: 'Go Back',
        confirmText: 'Ok',
        onCancel: () => Get.back(),
        onConfirm: () async {
          await logoutUser();
        },
      );
    } else {
      try {
        final ApiResponse<Map<String, dynamic>> res =
            await BookingRepository().customBookingEnquiry(cm);
        if (res.status == ApiResponseStatus.completed) {
          isloadingEnquiryButton.value = false;
          adult.value = 1;
          children.value = 0;
          Get.snackbar('Success', 'Tour Enquiry Submitted',
              colorText: Colors.white, backgroundColor: englishViolet);
          textFieldController.clear();
        } else {
          Get.snackbar('Sorry !!!', 'Tour Enquiry Not Submitted',
              colorText: Colors.white, backgroundColor: englishViolet);
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<void> logoutUser() async {
    final GetStorage storage = GetStorage();
    await storage.write('currentUserAddress', '');
    await storage.write('currentUserCategory', '');
    await storage.write('currentUserName', '');
    await storage.write('currentUserCountry', '');
    await storage.write('currentUserDistrict', '');
    await storage.write('currentUserEmail', '');
    await storage.write('currentUserEnterpriseName', '');
    await storage.write('currentUserGender', '');
    await storage.write('currentUserPhoneNumber', '');
    await storage.write('currentUserState', '');
    await FirebaseAuth.instance.signOut().then(
          (dynamic value) async => await Get.offAllNamed(Routes.GET_STARTED),
        );
  }

  // void onSerchBatchTourDateChanged(String text) {
  //   if (text.isNotEmpty) {
  //     batchTourPackageDatesRX.value = batchTourPackageDates
  //         .where(
  //           (PackageData package) => package.dateOfTravel!.contains(
  //             text,
  //           ),
  //         )
  //         .toList();
  //   } else {
  //     batchTourPackageDatesRX.value = batchTourPackageDates;
  //   }
  // }
}
