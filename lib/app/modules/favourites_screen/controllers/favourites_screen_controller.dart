import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/packages_repo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/favourites_screen_view.dart';

class FavouritesScreenController extends GetxController
    with StateMixin<FavouritesScreenView> {
  RxList<WishListModel> favouritesList = <WishListModel>[].obs;
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  GetStorage storage = GetStorage();
  String userType = '';
  int page = 1;
  RxBool hasReachedEnd = false.obs;
  List<int> tourIds = <int>[];
  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
    log('kiiuiuu 676');

    userType = await storage.read('user-type') as String;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    log('kiiuiuu 123');
  }

  Future<void> fetchAndStoreAllPackages() async {
    // Start fetching data from the first page (page 1)
    int currentPage = 1;
    ApiResponse<List<PackageModel>> res;

    do {
      try {
        // Fetch data for the current page
        res = await PackagesRepository().getAllPackages(currentPage);
        if (res.status == ApiResponseStatus.completed) {
          // Check if res.data is not null before adding to allPackages
          packageList.addAll(res.data!);
        }

        currentPage++; // Move to the next page for the next iteration
      } catch (e) {
        log(e.toString());
        break; // Stop fetching if an error occurs
      }
    } while (
        // ignore: use_if_null_to_convert_nulls_to_bools
        res.data?.isNotEmpty == true); // Continue fetching while there's data
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    await getData();
    change(null, status: RxStatus.success());
  }

  Future<void> getData() async {
    if (favouritesList.isNotEmpty && packageList.isNotEmpty) {
      favouritesList.clear();
      packageList.clear();
    }
    await getAllFavourites();
    await fetchAndStoreAllPackages();
  }

  Future<void> getAllFavourites() async {
    final ApiResponse<List<WishListModel>> res =
        await WishListRepo().getAllFav();
    log('ghdsyhsyb ${res.message}');
    if (res.data != null) {
      favouritesList.value = res.data!;
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  // Future<void> getAllPackages({int page = 1}) async {
  //   try {
  //     final ApiResponse<List<PackageModel>> res =
  //         await PackagesRepository().getAllPackages(page);
  //     if (res.status == ApiResponseStatus.completed) {
  //       final List<PackageModel> newData = res.data!;
  //       if (newData.isNotEmpty) {
  //         packageList.addAll(newData);
  //         this.page = page;

  //         if (newData.length < 10) {
  //           hasReachedEnd.value = true;
  //           loadMore();
  //         } else {
  //           loadMore();
  //         }
  //       } else {
  //         hasReachedEnd.value = true;
  //         // Empty response, indicating end of data
  //       }
  //     } else {
  //       // Error response
  //     }
  //   } catch (e) {
  //     // Exception occurred
  //   }
  // }

  // void loadMore() {
  //   final int nextPage = page + 1;
  //   getAllPackages(page: nextPage);
  // }

  Future<void> toggleFavorite(int productId) async {
    try {
      final bool isInWishList =
          packageList.any((PackageModel package) => package.id == productId);
      if (isInWishList) {
        await WishListRepo().deleteFav(productId);
        packageList
            .removeWhere((PackageModel package) => package.id == productId);
      } else {
        await WishListRepo().createFav(productId);
        final WishListModel wishList = favouritesList
            .firstWhere((WishListModel wishList) => wishList.id == productId);
        final PackageModel pckg = PackageModel(
          id: wishList.id,
          name: wishList.name,
          // add any other properties that are required for the wishlist item
        );
        packageList.add(pckg);
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  RxBool isFavorite(int productId) {
    return RxBool(packageList.any((PackageModel pckg) => pckg.id == productId));
  }

  Future<void> onSingleTourPressed(int id) async {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[id])!
        .whenComplete(() => loadData());
  }
}
