import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/packages_repo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/single_destination_view.dart';

class SingleDestinationController extends GetxController
    with StateMixin<SingleDestinationView> {
  String? destination;
  RxList<WishListModel> wishList = <WishListModel>[].obs;

  RxList<PackageModel> packages = <PackageModel>[].obs;
  int page = 1;
  bool isLoading = false;
  RxBool hasReachedEnd = false.obs;
  GetStorage storage = GetStorage();
  String userType = '';
  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
    userType = await storage.read('user-type') as String;
  }

  Future<void> loadData() async {
    if (packages.isNotEmpty) {
      packages.clear();
    }
    await getData();
    await getWishList();
  }

  Future<void> loadTour(String categoryName, {int page = 1}) async {
    try {
      final ApiResponse<List<PackageModel>> res = await PackagesRepository()
          .getAllPackagesByDestination(destination, page);
      if (res.status == ApiResponseStatus.completed) {
        final List<PackageModel> newData = res.data!;
        if (newData.isNotEmpty) {
          packages.addAll(newData);
          this.page = page;

          if (newData.length < 10) {
            hasReachedEnd.value = true;
          }
        } else {
          hasReachedEnd.value = true;
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
    loadTour(destination!, page: nextPage);
  }

  void onClickSingleTour(int i) {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[i])!
        .whenComplete(() => loadData());
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      destination = Get.arguments as String;
      await loadTour(destination.toString());
    }
  }

  Future<void> getWishList() async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.status == ApiResponseStatus.completed) {
      wishList.value = res.data! as List<WishListModel>;
      change(null, status: RxStatus.success());
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
        final PackageModel package = packages
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
}
