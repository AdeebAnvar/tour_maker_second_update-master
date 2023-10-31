// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_departure.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/custom_tab.dart';
import '../../../widgets/fixed_departure.dart';
import '../../../widgets/images.dart';
import '../controllers/single_tour_controller.dart';

class SingleTourView extends GetView<SingleTourController> {
  const SingleTourView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final SingleTourController controller = Get.put(SingleTourController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAPPBAR(controller),
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        (SingleTourView? state) => LiquidPullToRefresh(
          showChildOpacityTransition: false,
          color: Colors.transparent,
          animSpeedFactor: 3,
          springAnimationDurationInMilliseconds: 600,
          backgroundColor: englishViolet,
          onRefresh: controller.fetchData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: <Widget>[
                tourImge(controller),
                tourDetailContainer(screenWidth, controller, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomAppBar buildAPPBAR(SingleTourController controller) {
    return CustomAppBar(
      actions: <Widget>[
        if (controller.userType == 'demo')
          const SizedBox()
        else
          Obx(() {
            return GestureDetector(
              onTap: () => controller.onClickAddToFavourites(),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: controller.isFavourite.value
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_outline),
                ),
              ),
            );
          }),
        const SizedBox(
          width: 20,
          height: 20,
        )
      ],
    );
  }

  SingleChildScrollView tourDetailContainer(double screenWidth,
      SingleTourController controller, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: screenWidth - 70),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${controller.batchTour.value.tourData?.tourCode}',
                        style: heading2,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(controller.batchTour.value.tourData!.brandName ?? '',
                          style: subheading1),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text('Tour Description', style: heading3)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        '${controller.batchTour.value.tourData?.description}',
                        style: paragraph3,
                        textAlign: TextAlign.justify),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Obx(() {
                        return CustomButton().showButtonWithGradient(
                          isLoading:
                              controller.isloadingTheViewItinerraryButton.value,
                          text: 'View itinerary',
                          onPressed: () => controller.onViewItineraryClicked(
                              controller.batchTour.value.tourData!.itinerary!,
                              controller.batchTour.value.tourData!.tourCode!),
                        );
                      }),
                    ],
                  ),
                  if (controller.batchTourPackageDatesRX.isNotEmpty)
                    CustomTabBar(controller: controller)
                  else
                    const SizedBox(),
                  const SizedBox(height: 30),
                  if (controller.batchTourPackageDatesRX.isEmpty)
                    buildCustomDeparture()
                  else
                    Obx(
                      () => controller.selectedTabIndex.value == 0
                          ? buildFixedDeparture()
                          :
                          // : Column(
                          //     children: <Widget>[
                          //       CustomDatePickerField(
                          //         labelName: 'Select Tour Date',
                          //         validator: (String? value) {
                          //           return null;
                          //         },
                          //         onChange: (String value) => controller
                          //             .onSerchIndividualTourDateChanged(value),
                          //       ),
                          buildCustomDeparture(),
                      //   ],
                      // ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container tourImge(SingleTourController controller) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            '${controller.batchTour.value.tourData!.image}',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildCustomDeparture() => CustomDeparture(
      controller: controller,
      countOfAdults: countOfAdults(),
      countOfChildrens: countOfChildrens());

  Widget buildFixedDeparture() {
    if (controller.batchTourPackageDatesRX.isNotEmpty ||
        controller.hasReachedEndofBatchTours.value) {
      return FixedDepartures(
          controller: controller,
          countOfAdults: countOfAdults(),
          countOfChildrens: countOfChildrens());
    } else {
      return Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Image.asset(emptyImage),
          const SizedBox(height: 10),
          const Text(
            'No Fixed Departures \nfor this tour',
            textAlign: TextAlign.center,
          )
        ],
      );
    }
  }

  Widget countOfChildrens() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 100,
        height: 37,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () => controller.onClickSubtractChildren(),
              child: Container(
                width: 25,
                height: 25,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: englishViolet),
                child: Column(
                  children: const <Widget>[
                    Center(
                      child: Icon(
                        Icons.minimize,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(controller.children.value.toString()),
            GestureDetector(
              onTap: () => controller.onClickAddChildren(),
              child: Container(
                width: 25,
                height: 25,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: englishViolet),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget countOfAdults() {
    return Obx(
      () {
        return SizedBox(
          width: 100,
          height: 37,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => controller.onClickAdultSubtract(),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: englishViolet),
                  child: Column(
                    children: const <Widget>[
                      Center(
                        child: Icon(
                          Icons.minimize,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(controller.adult.value.toString()),
              GestureDetector(
                onTap: () => controller.onClickAdultAdd(),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: englishViolet),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
