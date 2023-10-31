// ignore_for_file: always_specify_types

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../data/models/network_models/category_model.dart';
import '../../../data/models/network_models/exclusivetour_model.dart';
import '../../../data/models/network_models/model.dart';
import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/single_tour_type_model.dart';
import '../../../data/models/network_models/tour_type_model.dart';
import '../../../data/models/network_models/travveltypes_model.dart';
import '../../../data/models/network_models/trending_tours.dart';
import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/category_repo.dart';
import '../../../data/repo/network_repo/exclusive_repo.dart';
import '../../../data/repo/network_repo/mainscreen_service.dart';
import '../../../data/repo/network_repo/tour_type_repo.dart';
import '../../../data/repo/network_repo/traveltypes_repo.dart';
import '../../../data/repo/network_repo/trending_tours_rep.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/custom_functions/firebase_functions.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../../../widgets/custom_search_delegate.dart';

class MainScreenController extends GetxController {
  GetStorage getStorage = GetStorage();
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<TrendingToursModel> trendingToursList = <TrendingToursModel>[].obs;
  RxList<ExclusiveToursModel> exclusiveToursList = <ExclusiveToursModel>[].obs;
  RxList<TravelTypesModel> travelTypesToursList = <TravelTypesModel>[].obs;
  RxList<SingleTourTypeModel> singleTourTypeList = <SingleTourTypeModel>[].obs;
  RxList<TourTypeResult> tourTypeList = <TourTypeResult>[].obs;
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  Rx<bool> isInternetConnect = true.obs;
  TextEditingController textController = TextEditingController();
  MyCustomSearchDelegate delegate = MyCustomSearchDelegate();
  final FocusNode searchFocusNode = FocusNode();
  String? customerID;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool screenLoading = false.obs;

  /// //// ///// ///// //// //// //// //// ///// //// //// //// //// /// ///
  RxList<CategoriesAPIResult> result = <CategoriesAPIResult>[].obs;
  RxBool loading = true.obs;
  RxList<TourResult> tourResult = <TourResult>[].obs;
  RxList<Exclusive> exclusive = <Exclusive>[].obs;
  RxList<TravelType> travelType = <TravelType>[].obs;

  Future<List<CategoriesAPIResult>?> getCategoriesResult() async {
    try {
      var data = await CategoryRepository.getAllCategory();
      loading.value = false;
      return data;
    } catch (e) {
      loading.value = false;
    }
    return null;
  }

  /// //// //// //
  @override
  void onInit() {
    super.onInit();
    // checkNetwork();
    getCategoriesResult().then((value) => result.value = value!);
    getTrending().then((value) => tourResult.value = value!);
    fetchExclusiveTours().then((value) => exclusive.value = value!);
    getTravelTypeResult().then((value) => travelType.value = value!);
    getAllTourTypes().then((value) => tourTypeList.value = value!);
    update();

    log('fygubhnjkm ${auth.currentUser}');
  }

  // Future<void> loadData() async {
  //   // change(null, status: RxStatus.loading());
  //   await getData();
  //   // change(null, status: RxStatus.success());
  // }

  // Future<void> getData() async {
  //   await getTrending().then((value) async {
  //     await getExclusive().then((value) async {
  //       await getTravelTypes().then((value) async {
  //         await getAllTourTypes();
  //       });
  //     });
  //   });
  //   // await getCategory().then((value) async {

  //   // });

  //   customerID = await getUser();
  //   await storage.write('customer_Id', customerID);
  // }

  void refreshController() {
    getCategoriesResult();
    getTrending();
    getTrending();
    fetchExclusiveTours();
    getTravelTypeResult();
    getAllTourTypes();
    update();
  }

  // Future<void> checkNetwork() async {
  //   isInternetConnect.value = await InternetConnectionChecker().hasConnection;
  //   isInternetConnect.value != true
  //       ? Get.toNamed(Routes.NOINTERNET)
  //       : loadData();
  // }

  void onSearchClicked() {
    searchFocusNode.unfocus();
    Get.toNamed(Routes.SEARCH_VIEW)!.whenComplete(() => refreshController());
  }

  Future<List<TourResult>?> getTrending() async {
    try {
      final data = await MainScreenServices.getAllTrendingTours();
      log('$data===data');
      loading.value = false;
      update();
      return data;
    } on DioException catch (e) {
      loading.value = false;

      log(e.error.toString());
      log(e.message.toString());
      log(e.toString());
    } catch (e) {
      loading.value = false;
      log(e.toString());
    }
    return null;
  }

  // Future<void> getCategory() async {
  //   screenLoading.value = true;
  //   await CategoryRepository()
  //       .getAllCategory()
  //       .then((ApiResponse<List<CategoryModel>> res) async {
  //     try {
  //       if (res.status == ApiResponseStatus.completed) {
  //         categoryList.value = res.data!;
  //         screenLoading.value = false;
  //       }
  //     } catch (e) {
  //       screenLoading.value = false;
  //       CustomDialog().showCustomDialog('Error !', contentText: e.toString());
  //     }
  //   });
  // }

  Future<List<Exclusive>?> fetchExclusiveTours() async {
    try {
      final data = await MainScreenServices.getExclusiveTourss();
      log('$data===data');
      loading.value = false;
      update();
      return data;
    } on DioException catch (e) {
      loading.value = false;

      log(e.error.toString());
      log(e.message.toString());
      log(e.toString());
    } catch (e) {
      loading.value = false;
      log(e.toString());
    }
    return null;
  }

  ///
  ///
  ///
  Future<List<TravelType>?> getTravelTypeResult() async {
    try {
      final data = await MainScreenServices.fetchTravelType();
      log('$data===data');
      loading.value = false;
      update();
      return data;
    } on DioException catch (e) {
      loading.value = false;

      log(e.error.toString());
      log(e.message.toString());
      log(e.toString());
    } catch (e) {
      loading.value = false;
      log(e.toString());
    }
    return null;
  }
  // Future<void> getTrending() async {
  //   log('thanos');

  //   await TrendingToursRepository()
  //       .getAllTrendingTours()
  //       .then((ApiResponse<List<TrendingToursModel>> res) async {
  //     try {
  //       if (res.status == ApiResponseStatus.completed) {
  //         trendingToursList.value = res.data!;
  //       }
  //     } catch (e) {
  //       CustomDialog().showCustomDialog('Error !', contentText: e.toString());
  //     }
  //   });
  // }

  Future<List<TourTypeResult>?> getAllTourTypes() async {
    // await TourTypeRepo()
    //     .getAllTourTypes()
    //     .then((ApiResponse<List<TourTypesModel>> res) async {
    //   try {
    //     if (res.status == ApiResponseStatus.completed) {
    //       tourTypeList.value = res.data!;
    //     }
    //   } catch (e) {
    //     CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    //   }
    // });
    try {
      final data = await MainScreenServices.fetchTourType();
      log('$data===data');
      loading.value = false;
      update();
      return data;
    } on DioException catch (e) {
      loading.value = false;

      log(e.error.toString());
      log(e.message.toString());
      log(e.toString());
    } catch (e) {
      loading.value = false;
      log(e.toString());
    }
    return null;
  }

  // Future<void> getExclusive() async {
  //   await ExclusiveTourRepository()
  //       .getAllExclusiveTours()
  //       .then((ApiResponse<List<ExclusiveToursModel>> res) async {
  //     try {
  //       if (res.status == ApiResponseStatus.completed) {
  //         exclusiveToursList.value = res.data!;
  //       }
  //     } catch (e) {
  //       CustomDialog().showCustomDialog('Error !', contentText: e.toString());
  //     }
  //   });
  // }

  // Future<void> getTravelTypes() async {
  //   await TravelTypesRepository()
  //       .getAllTravelTypesTours()
  //       .then((ApiResponse<List<TravelTypesModel>> res) async {
  //     try {
  //       if (res.status == ApiResponseStatus.completed) {
  //         travelTypesToursList.value = res.data!;
  //       }
  //     } catch (e) {
  //       CustomDialog().showCustomDialog('Error !', contentText: e.toString());
  //     }
  //   });
  // }

  void onClickedSingleCategoryTour(String name, String image) {
    Get.toNamed(Routes.SINGLE_CATEGORY, arguments: <String>[name, image]);
  }

  void onClickedSingleTravelTypeTour(String? name) {
    Get.toNamed(Routes.TRAVEL_TYPES, arguments: name);
  }

  void onClickSingleExclusiveTour(String? name) {
    Get.toNamed(Routes.EXCLUSIVE_TOURS, arguments: name);
  }

  Future<void> onClickSingleTrendingTour(String? destination) async {
    Get.toNamed(Routes.TRENDING_TOURS, arguments: destination);
  }

  void onClickSingleTourType(String destination) {
    Get.toNamed(Routes.SINGLE_DESTINATION, arguments: destination);
  }

  Future<String> getUser() async {
    try {
      final ApiResponse<UserModel> res =
          await UserRepository().getUserDetails();

      if (res.status == ApiResponseStatus.completed) {
        final UserModel user = res.data!;
        return user.customerId.toString();
      } else {
        return '';
      }
    } catch (e) {
      log(e.toString());
      return '';
    }
  }
}
