import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/theme/style.dart';

import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/package_tile.dart';
import '../controllers/favourites_screen_controller.dart';

class FavouritesScreenView extends GetView<FavouritesScreenController> {
  const FavouritesScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final FavouritesScreenController controller =
        Get.put(FavouritesScreenController());
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Favourites')),
      body: controller.obx(
        onEmpty: CustomErrorScreen(
          errorText: 'No Packages \n Wishlisted',
          onRefresh: () => controller.loadData(),
        ),
        onLoading: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return CustomShimmer(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: 145,
                height: 162,
                borderRadius: BorderRadius.circular(12),
              );
            }),
        (FavouritesScreenView? state) => LiquidPullToRefresh(
          showChildOpacityTransition: false,
          color: Colors.transparent,
          animSpeedFactor: 3,
          springAnimationDurationInMilliseconds: 600,
          backgroundColor: englishViolet,
          onRefresh: controller.getData,
          child: Obx(
            () => controller.favouritesList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.favouritesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final WishListModel wishListModel =
                          controller.favouritesList[index];
                      for (final PackageModel pm in controller.packageList) {
                        if (pm.id == wishListModel.tourId) {
                          controller.isFavorite(wishListModel.id!).value = true;
                        } else {
                          controller.isFavorite(wishListModel.id!).value =
                              false;
                        }
                      }
                      return Obx(() {
                        return PackageTile(
                          userType: controller.userType,
                          brandName: '',
                          tourAmount: wishListModel.minAmount.toString(),
                          tourCode: wishListModel.tourCode.toString(),
                          tourDays: wishListModel.days.toString(),
                          tourImage: wishListModel.image.toString(),
                          tourName: wishListModel.name.toString(),
                          tournights: wishListModel.nights.toString(),
                          isFavourite:
                              controller.isFavorite(wishListModel.id!).value,
                          onClickedFavourites: () =>
                              controller.toggleFavorite(wishListModel.id!),
                          onPressed: () =>
                              controller.onSingleTourPressed(wishListModel.id!),
                        );
                      });
                    },
                  )
                : CustomErrorScreen(
                    onRefresh: () => controller.loadData(),
                    errorText: 'No Packages \n Wishlisted'),
          ),
        ),
      ),
    );
  }
}
