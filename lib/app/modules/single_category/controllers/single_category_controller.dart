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
import '../views/single_category_view.dart';

class SingleCategoryController extends GetxController
    with StateMixin<SingleCategoryView> {
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  Rx<String> categoryName = ''.obs;
  Rx<String> categoryImage = ''.obs;
  RxList<WishListModel> wishList = <WishListModel>[].obs;
  int page = 1;
  // bool isLoading = false;
  RxBool hasReachedEnd = false.obs;
  String userType = '';
  GetStorage storage = GetStorage();
  @override
  Future<void> onInit() async {
    super.onInit();

    loadData().whenComplete(() => change(null, status: RxStatus.success()));
    userType = await storage.read('user-type') as String;
    log('gb $userType');
  }

  Future<void> loadData() async {
    // change(null, status: RxStatus.loading());

    await getData();
  }

  Future<void> getData() async {
    if (packageList.isNotEmpty) {
      packageList.clear();
    }
    if (Get.arguments != null) {
      categoryName.value = Get.arguments[0] as String;
      categoryImage.value = Get.arguments[1] as String;
      await loadCategoryPackages(categoryName.value);
      await getWishList();
    } else {
      // Handle case when no arguments are passed
    }
  }

  void onSingleTourPressed(PackageModel pckg) {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[pckg.id!]);
  }

  Future<void> getWishList() async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.data != null) {
      wishList.value = res.data! as List<WishListModel>;
    } else {
      // Handle case when wish list data is null
    }
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      final bool isInWishList =
          wishList.any((WishListModel package) => package.id == productId);
      if (isInWishList) {
        await WishListRepo().deleteFav(productId);
        wishList
            .removeWhere((WishListModel package) => package.id == productId);
      } else {
        await WishListRepo().createFav(productId);
        // final PackageModel package = singleCategoryList
        //     .firstWhere((PackageModel package) => package.id == productId);
        // wishlists.add(package as WishListModel);
        final PackageModel package = packageList
            .firstWhere((PackageModel package) => package.id == productId);
        final WishListModel wishlistItem = WishListModel(
          id: package.id,
          name: package.name,
          // add any other properties that are required for the wishlist item
        );
        wishList.add(wishlistItem);
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  RxBool isFavorite(int productId) =>
      RxBool(wishList.any((WishListModel package) => package.id == productId));

  Future<void> loadCategoryPackages(String categoryName, {int page = 1}) async {
    try {
      final ApiResponse<List<PackageModel>> res = await PackagesRepository()
          .getCategorybycategoryName(categoryName, page);
      log('ghdsyhsyb ${res.message}');

      if (res.data != null) {
        final List<PackageModel> newData = res.data!;
        if (newData.isNotEmpty) {
          log('ghdsyhsyb 1');

          packageList.addAll(newData);
          this.page = page;
          if (newData.length <= 10) {
            hasReachedEnd.value = true;
            loadMore();
          } else {
            log('ghdsyhsyb 3');
          }
        } else {
          log('ghdsyhsyb 4');
          // hasReachedEnd.value = true;
          // Empty response, indicating end of data
        }
      } else {
        // Error response
      }
    } catch (e) {
      // Exception occurred
    }
  }

  void loadMore() {
    final int nextPage = page + 1;
    loadCategoryPackages(categoryName.value, page: nextPage);
  }
}
