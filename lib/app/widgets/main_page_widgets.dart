import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';
import '../../core/tour_maker_icons.dart';
import '../data/models/network_models/exclusivetour_model.dart';
import '../data/models/network_models/model.dart';
import '../data/models/network_models/tour_type_model.dart';
import '../modules/main_screen/controllers/main_screen_controller.dart';
import 'custom_shimmer.dart';
import 'images.dart';

class BuildHeadSection extends StatelessWidget {
  BuildHeadSection({super.key});

  final MainScreenController maincontroller = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 44.h,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.bounceIn,
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              image: DecorationImage(
                image: AssetImage(homeScreenFeatureImage),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 100),
            child: Image.asset(homeScreenLogo, height: 50),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: screenHeight * 0.30),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                // type: MaterialType.transparency,
                child: TextField(
                  //enabled: false,
                  focusNode: maincontroller.searchFocusNode,
                  controller: maincontroller.textController,
                  onTap: () => maincontroller.onSearchClicked(),
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(TourMaker.search,
                          color: englishViolet, size: 30),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search in Destinations',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///
///
///
class TrendingTours extends StatelessWidget {
  const TrendingTours({super.key});

  @override
  Widget build(BuildContext context) {
    // final MainScreenController controller = Get.put(MainScreenController());
    final MainScreenController maincontroller = Get.put(MainScreenController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Obx(
          () => maincontroller.loading.value
              ? CustomShimmer(
                  height: screenHeight * 0.30,
                  borderRadius: BorderRadius.circular(30),
                )
              : SizedBox(
                  height: screenHeight * 0.30,
                  child: CarouselSlider(
                    // itemCount: controller.trendingToursList.length,
                    options: CarouselOptions(
                        height: screenHeight * 0.30,
                        aspectRatio: 3 / 4,
                        enlargeCenterPage: true,
                        viewportFraction: 0.5,
                        autoPlay: true,
                        disableCenter: true),

                    items: maincontroller.tourResult
                        .map((TourResult item) => GestureDetector(
                              onTap: () => maincontroller
                                  .onClickSingleTrendingTour(item.destination),
                              child: SizedBox(
                                height: 0.25.h,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.image.toString(),
                                    fit: BoxFit.cover,
                                    width: 100.w,
                                    errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) =>
                                        Padding(padding: EdgeInsets.all(3.w)),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return CustomShimmer(
                                        height: 55,
                                        width: 55,
                                        borderRadius: BorderRadius.circular(10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }
}

///
///
///

class CategoriesSectionTours extends StatelessWidget {
  CategoriesSectionTours({super.key});

  final MainScreenController controller = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.loading.value) {
          return CustomShimmer(
            width: 1000,
            borderRadius: BorderRadius.circular(20),
            height: 300,
          );
        } else if (controller.result.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
          // return CustomShimmer(
          //   width: 1000,
          //   borderRadius: BorderRadius.circular(20),
          //   height: 200,
          // );
        }

        return Card(
          margin: const EdgeInsets.all(15),
          elevation: 5,
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 21.0),
                      child: Text('   Explore',
                          style:
                              paragraph1.copyWith(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 30),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.result.length,
                    physics: controller.result.length <= 8
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 40,
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => controller.onClickedSingleCategoryTour(
                          controller.result[index].name.toString(),
                          controller.result[index].image.toString(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                controller.result[index].image!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) =>
                                    Padding(padding: EdgeInsets.all(3.w)),
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return CustomShimmer(
                                    height: 55,
                                    width: 55,
                                    borderRadius: BorderRadius.circular(10),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 14,
                              width: 22.w,
                              child: Center(
                                child: Text(
                                  controller.result[index].name.toString(),
                                  overflow: TextOverflow.visible,
                                  style: subheading3.copyWith(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}

///
///
///
class ExclusiveTours extends StatelessWidget {
  ExclusiveTours({super.key});
  final MainScreenController maincontroller = Get.put(MainScreenController());
  @override
  Widget build(BuildContext context) {
    // final MainScreenController maincontroller = Get.put(MainScreenController());
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Obx(
          () => maincontroller.loading.value
              ? CustomShimmer(
                  height: screenHeight * 0.35,
                  borderRadius: BorderRadius.circular(30),
                )
              : SizedBox(
                  height: screenHeight * 0.35,
                  child: CarouselSlider(
                    // itemCount: controller.trendingToursList.length,
                    options: CarouselOptions(
                        height: screenHeight * 0.35,
                        aspectRatio: 3 / 4,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        autoPlay: true,
                        disableCenter: true),

                    items: maincontroller.exclusive
                        .map((Exclusive item) => GestureDetector(
                              onTap: () => maincontroller
                                  .onClickSingleExclusiveTour(item.name),
                              child: SizedBox(
                                height: 0.25.h,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.image.toString(),
                                    fit: BoxFit.cover,
                                    width: 100.w,
                                    errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) =>
                                        Padding(padding: EdgeInsets.all(3.w)),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return CustomShimmer(
                                        height: screenHeight * 0.30,
                                        width: 171,
                                        borderRadius: BorderRadius.circular(10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }
}

///
///
///
class TravelTypes extends StatelessWidget {
  TravelTypes({super.key});

  final MainScreenController maincontroller = Get.put(MainScreenController());
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      if (maincontroller.loading.value) {
        return CustomShimmer(
          margin: const EdgeInsets.all(7),
          height: 100,
          borderRadius: BorderRadius.circular(18),
          width: screenWidth * 0.75,
        );
      }
      if (maincontroller.travelType.isEmpty) {
        return CustomShimmer(
          margin: const EdgeInsets.all(7),
          height: 100,
          borderRadius: BorderRadius.circular(18),
          width: screenWidth * 0.75,
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(homeScreenImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 20.0),
                  child: Text(
                    'TravelTypes',
                    style: paragraph1.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maincontroller.travelType.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () => maincontroller.onClickedSingleTravelTypeTour(
                        maincontroller.travelType[index].name),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        maincontroller.travelType[index].image!,
                        width: screenWidth * 0.75,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) =>
                            Padding(padding: EdgeInsets.all(3.w)),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          print("loading 11111");
                          if (loadingProgress == null) {
                            print("loading 22222");
                            return child;
                          }
                          return CustomShimmer(
                            height: 100,
                            width: screenWidth * 0.75,
                            borderRadius: BorderRadius.circular(10),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      );
    });
  }
}

class TourTypes extends StatelessWidget {
  TourTypes({super.key});
  final MainScreenController maincontroller = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      if (maincontroller.loading.value) {
        return CustomShimmer(
          margin: const EdgeInsets.all(7),
          height: 100,
          borderRadius: BorderRadius.circular(18),
          width: screenWidth * 0.75,
        );
      }
      if (maincontroller.tourTypeList.isEmpty) {
        return CustomShimmer(
          margin: const EdgeInsets.all(7),
          height: 100,
          borderRadius: BorderRadius.circular(18),
          width: screenWidth * 0.75,
        );
      }
      return SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: maincontroller.tourTypeList.length,
          itemBuilder: (BuildContext context, int tourTypeIndex) {
            // final TourTypesModel tourType = maincontroller.tourTypeList[tourTypeIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, top: 3.0, bottom: 1.0),
                  child: Text(
                    maincontroller.tourTypeList[tourTypeIndex].tourType
                        .toString(),
                    style: paragraph1.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: maincontroller
                        .tourTypeList[tourTypeIndex].tours?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final List<TourTypesListModel>? tourtypes =
                          maincontroller.tourTypeList[tourTypeIndex].tours;
                      return GestureDetector(
                        onTap: () => maincontroller.onClickSingleTourType(
                            tourtypes[index].destination.toString()),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCirc,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 4),
                          // padding: const EdgeInsets.all(10),
                          width: 85,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            image: DecorationImage(
                              image: NetworkImage(
                                tourtypes![index].image.toString(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Flexible(
                                      flex: 38,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: <Color>[
                                              Colors.transparent,
                                              Colors.black,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      )),
                                  Flexible(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    tourtypes[index].name.toString(),
                                    style: paragraph3.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      );
    });
  }
}
