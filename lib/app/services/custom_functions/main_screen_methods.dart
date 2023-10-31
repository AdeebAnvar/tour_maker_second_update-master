import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../core/theme/style.dart';
import '../../../core/tour_maker_icons.dart';
import '../../data/models/network_models/tour_type_model.dart';
import '../../data/models/network_models/trending_tours.dart';
import '../../modules/main_screen/controllers/main_screen_controller.dart';
import '../../widgets/custom_cached_network_image.dart';
import '../../widgets/custom_shimmer.dart';
import '../../widgets/images.dart';

SizedBox tourTypes(MainScreenController controller) {
  return SizedBox(
    child: ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.tourTypeList.length,
      itemBuilder: (BuildContext context, int tourTypeIndex) {
        // final TourTypesModel tourType = controller.tourTypeList[tourTypeIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 3.0, bottom: 1.0),
              child: Text(
                controller.tourTypeList[tourTypeIndex].tourType.toString(),
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
                itemCount: controller.tourTypeList[tourTypeIndex].tours?.length,
                itemBuilder: (BuildContext context, int index) {
                  final List<TourTypesListModel>? tourtypes =
                      controller.tourTypeList[tourTypeIndex].tours;
                  return GestureDetector(
                    onTap: () => controller.onClickSingleTourType(
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
                                      borderRadius: BorderRadius.circular(10),
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
}

Widget travelTypes(
    double screenHeight, double screenWidth, MainScreenController controller) {
  return Obx(
    () => controller.travelTypesToursList.isEmpty
        ? CustomShimmer(
            margin: const EdgeInsets.all(7),
            height: 100,
            borderRadius: BorderRadius.circular(18),
            width: screenWidth * 0.75,
          )
        : Container(
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
                  itemCount: controller.travelTypesToursList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: () => controller.onClickedSingleTravelTypeTour(
                            controller.travelTypesToursList[index].name),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          child: CustomCachedNetworkImage(
                            shimmerWidth: screenWidth * 0.75,
                            shimmerHeight: 100,
                            imageUrl: controller
                                .travelTypesToursList[index].image
                                .toString(),
                            containerHeight: 100,
                            containerWidth: screenWidth * 0.75,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
  );
}

Widget exclusiveTours(
    double screenHeight, double screenWidth, MainScreenController controller) {
  return Obx(
    () => controller.exclusiveToursList.isEmpty
        ? CustomShimmer(
            height: screenHeight * 0.35,
            borderRadius: BorderRadius.circular(30),
          )
        : SizedBox(
            height: screenHeight * 0.35,
            child: CarouselSlider.builder(
              itemCount: controller.exclusiveToursList.length,
              options: CarouselOptions(
                  reverse: true,
                  height: screenHeight * 0.35,
                  aspectRatio: 3 / 4,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlay: true,
                  autoPlayCurve: Curves.bounceIn,
                  disableCenter: true),
              itemBuilder: (BuildContext context, int index, int realIndex) =>
                  Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  onTap: () => controller.onClickSingleExclusiveTour(
                      controller.exclusiveToursList[index].name),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                    child: CustomCachedNetworkImage(
                      shimmerHeight: screenHeight * 0.30,
                      imageUrl:
                          controller.exclusiveToursList[index].image.toString(),
                      borderRadius: BorderRadius.circular(10),
                      shimmerWidth: 171,
                      containerWidth: screenWidth * 0.75,
                      containerHeight: screenHeight * 0.30,
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}

Widget trendingTours(double screenHeight, MainScreenController controller) {
  return Obx(
    () => controller.trendingToursList.isEmpty
        ? CustomShimmer(
            height: screenHeight * 0.30,
            borderRadius: BorderRadius.circular(30),
          )
        : SizedBox(
            height: screenHeight * 0.30,
            child: CarouselSlider(
              options: CarouselOptions(
                height: screenHeight * 0.30,
                aspectRatio: 3 / 4,
                enlargeCenterPage: true,
                viewportFraction: 0.5,
                autoPlay: true,
                autoPlayCurve: Curves.bounceOut,
                disableCenter: true,
              ),
              items: controller.trendingToursList
                  .map(
                    (TrendingToursModel item) => GestureDetector(
                      // onTap: () => launchURL(item.url),
                      child: SizedBox(
                        height: 0.25.h,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Image.network(
                            item.image.toString(),
                            fit: BoxFit.cover,
                            width: 100.w,
                            errorBuilder: (BuildContext context, Object error,
                                    StackTrace? stackTrace) =>
                                Padding(
                              padding: EdgeInsets.all(3.0.w),
                              child: Image.network(homeScreenFeatureImage),
                            ),
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(
                                  //   child: ShimmerWidget.rectangular(
                                  // height: size.height * 0.27,
                                  // )
                                  );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
  );
}

Widget categoriesSectionTours(
    double screenHeight, MainScreenController controller) {
  return Obx(() {
    if (controller.result.isEmpty) {
      return CustomShimmer(
        width: 1000,
        borderRadius: BorderRadius.circular(20),
        height: 200,
      );
    } else {
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
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 30),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: controller.result.length,
                physics: controller.result.length <= 8
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 40,
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return buildCategoryImageCard(controller, index);
                },
              ),
            ),
          ],
        ),
      );
    }
  });
}

GestureDetector buildCategoryImageCard(
    MainScreenController controller, int index) {
  return GestureDetector(
    onTap: () => controller.onClickedSingleCategoryTour(
      controller.result[index].name.toString(),
      controller.result[index].image.toString(),
    ),
    child: Hero(
      tag: controller.result[index],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CachedNetworkImage(
            key: UniqueKey(),
            cacheKey: UniqueKey().toString(),
            fadeInCurve: Curves.bounceInOut,
            placeholder: (BuildContext context, String url) => CustomShimmer(
              height: 55,
              width: 55,
              borderRadius: BorderRadius.circular(10),
            ),
            imageUrl: controller.result[index].image.toString(),
            imageBuilder:
                (BuildContext context, ImageProvider<Object> imageProvider) {
              return CircleAvatar(
                backgroundImage: imageProvider,
                radius: 28,
              );
            },
            errorWidget: (BuildContext context, String url, error) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
              );
            },
          ),
          SizedBox(
            height: 14,
            width: 22.w,
            child: Center(
              child: Text(
                controller.result[index].name.toString(),
                overflow: TextOverflow.visible,
                style: paragraph4.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

SizedBox buildHeadSection(double screenHeight, BuildContext context,
    MainScreenController controller) {
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
            padding:
                EdgeInsets.only(left: 20, right: 20, top: screenHeight * 0.30),
            child: Material(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              // type: MaterialType.transparency,
              child: TextField(
                //enabled: false,
                focusNode: controller.searchFocusNode,
                controller: controller.textController,
                onTap: () => controller.onSearchClicked(),
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child:
                        Icon(TourMaker.search, color: englishViolet, size: 30),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search Destinations',
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
