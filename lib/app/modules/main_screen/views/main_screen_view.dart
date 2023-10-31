import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/theme/style.dart';
import '../../../widgets/main_page_widgets.dart';
import '../controllers/main_screen_controller.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final MainScreenController controller = Get.put(MainScreenController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // void refreshData() {
    //   controller.exclusive;
    //   controller.result;
    //   controller.tourResult;
    //   controller.travelType;
    // }

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          controller.refreshController();
          controller.onInit();
        },
        color: Colors.transparent,
        showChildOpacityTransition: false,
        animSpeedFactor: 3,
        springAnimationDurationInMilliseconds: 600,
        backgroundColor: englishViolet,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeadSection(),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoriesSectionTours(),
                  const SizedBox(height: 20),
                  Text(
                    '     Offers zone',
                    style: paragraph1.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ui.trendingTours(screenHeight, controller),
                  const TrendingTours(),
                  const SizedBox(height: 20),
                  Text('     Exclusive Tours',
                      style: paragraph1.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  ExclusiveTours(),
                  //  ui.exclusiveTours(screenHeight, screenWidth, controller),
                  const SizedBox(height: 20),

                  TravelTypes(),
                  // const SizedBox(height: 10),
                  TourTypes()
                ],
              )

              // TrendingTours()
            ],
          ),
        ),
      ),
    );
  }
}
