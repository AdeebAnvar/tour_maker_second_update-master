import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../data/models/network_models/package_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/package_tile.dart';
import '../controllers/search_details_controller.dart';

class SearchDetailsView extends GetView<SearchDetailsController> {
  const SearchDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    final SearchDetailsController controller =
        Get.put(SearchDetailsController());
    return Scaffold(
        appBar: CustomAppBar(
          title: Text(controller.destinationValue.toString()),
          actions: <Widget>[
            IconButton(
              onPressed: () => controller.onClickFilter(),
              icon: Icon(
                TourMaker.filter,
                color: englishViolet,
              ),
            ),
          ],
        ),
        body: controller.obx(
          onLoading: const CustomLoadingScreen(),
          onEmpty: CustomErrorScreen(
              errorText:
                  'No destinations in \n ${controller.destinationValue}'),
          (SearchDetailsView? state) => Center(
              child: ListView.builder(
            itemCount: controller.destinations.length,
            itemBuilder: (BuildContext context, int index) => Obx(() {
              final PackageModel package = controller.destinations[index];
              return Obx(() {
                return PackageTile(
                  userType: controller.userType,
                  brandName: package.brandName.toString(),
                  tourAmount: package.amount.toString(),
                  tourCode: package.tourCode.toString(),
                  tourDays: package.days.toString(),
                  tourImage: package.image.toString(),
                  tourName: package.name.toString(),
                  tournights: package.nights.toString(),
                  isFavourite: controller.isFavorite(package.id!).value,
                  onClickedFavourites: () =>
                      controller.toggleFavorite(package.id!),
                  onPressed: () => controller
                      .onSingleTourPressed(controller.destinations[index].id!),
                );
              });
            }),
          )),
        ));
  }
}
