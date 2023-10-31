import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/network_models/package_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/package_tile.dart';
import '../controllers/tours_view_controller.dart';

class ToursViewView extends GetView<ToursViewController> {
  const ToursViewView({super.key});
  @override
  Widget build(BuildContext context) {
    final ToursViewController controller = Get.put(ToursViewController());
    return Scaffold(
      appBar: const CustomAppBar(),
      body: controller.obx(
        onEmpty: const CustomErrorScreen(errorText: 'Nothing found Here'),
        onLoading: const CustomLoadingScreen(),
        (ToursViewView? state) => controller.dataList.isEmpty
            ? const CustomErrorScreen(errorText: 'Nothing found Here')
            : ListView.builder(
                itemCount: controller.dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  final PackageModel package = controller.dataList[index];
                  return Obx(() {
                    return PackageTile(
                      userType: controller.userType,
                      brandName: package.brandName.toString(),
                      isFavourite: controller.isFavorite(package.id!).value,
                      onClickedFavourites: () =>
                          controller.toggleFavorite(package.id!),
                      onPressed: () => controller
                          .onClickSingleTour(controller.dataList[index].id!),
                      tourAmount: package.amount.toString(),
                      tourCode: package.tourCode.toString(),
                      tourDays: package.days.toString(),
                      tourImage: package.image.toString(),
                      tourName: package.name.toString(),
                      tournights: package.nights.toString(),
                    );
                  });
                },
              ),
      ),
    );
  }
}
