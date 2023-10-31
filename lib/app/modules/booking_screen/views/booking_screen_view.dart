import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_shimmer.dart';
import '../controllers/booking_screen_controller.dart';

class BookingScreenView extends GetView<BookingScreenController> {
  const BookingScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final BookingScreenController controller =
        Get.put(BookingScreenController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Bookings',
          style: TextStyle(color: fontColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 17),
              child: Container(
                height: 60,
                width: 100.w,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFF1F1F1),
                ),
                child: TabBar(
                  controller: controller.tabcontroller,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: englishViolet,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  tabs: const <Widget>[
                    Tab(
                      child: Text('Pending'),
                    ),
                    Tab(
                      child: Text('Completed'),
                    ),
                    Tab(
                      child: Text('Cancelled'),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: tabViewSection(controller),
            ),
          ),
        ],
      ),
    );
  }

  TabBarView tabViewSection(BookingScreenController controller) {
    return TabBarView(
      controller: controller.tabcontroller,
      children: <Widget>[
        buildPendingView(),
        buildCompletedView(),
        buildCancelledView(),
      ],
    );
  }

  Widget buildCompletedView() {
    return Obx(
      () {
        return LiquidPullToRefresh(
          onRefresh: controller.getData,
          showChildOpacityTransition: false,
          color: Colors.transparent,
          animSpeedFactor: 3,
          springAnimationDurationInMilliseconds: 600,
          backgroundColor: englishViolet,
          child: controller.isLoading.value == true
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomShimmer(
                      height: 88,
                      margin: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(18),
                    );
                  })
              : controller.completedList.isNotEmpty
                  ? completedList()
                  : CustomErrorScreen(
                      errorText: 'No Completed bookings ',
                      onRefresh: controller.loadData,
                    ),
        );
      },
    );
  }

  ListView completedList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.completedList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCompletedBookingTile(
          index,
          controller.getTotalTravellers(
            controller.completedList[index].noOfAdults!,
            controller.completedList[index].noOfKids!,
          ),
        );
      },
    );
  }

  Widget buildCancelledView() {
    return Obx(() {
      return LiquidPullToRefresh(
        onRefresh: controller.loadData,
        color: englishViolet,
        child: controller.isLoading.value == true
            ? ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return CustomShimmer(
                    height: 88,
                    margin: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(18),
                  );
                })
            : controller.cancelledList.isNotEmpty
                ? cancelledList()
                : CustomErrorScreen(
                    errorText: 'No Cancelled bookings',
                    onRefresh: controller.loadData,
                  ),
      );
    });
  }

  ListView cancelledList() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.cancelledList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildCancelledBookingTile(
            index,
            controller.getTotalTravellers(
              controller.cancelledList[index].noOfAdults!,
              controller.cancelledList[index].noOfKids!,
            ),
          );
        });
  }

  Widget buildPendingView() {
    return Obx(() {
      return LiquidPullToRefresh(
        onRefresh: controller.loadData,
        color: englishViolet,
        child: controller.isLoading.value == true
            ? ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return CustomShimmer(
                    height: 88,
                    margin: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(18),
                  );
                })
            : controller.pendingList.isNotEmpty
                ? pendingList()
                : CustomErrorScreen(
                    errorText: 'No Upcoming\n bookings',
                    onRefresh: controller.loadData,
                  ),
      );
    });
  }

  ListView pendingList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.pendingList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildPendingBookingTile(
          index,
          controller.getTotalTravellers(
            controller.pendingList[index].noOfAdults!,
            controller.pendingList[index].noOfKids!,
          ),
        );
      },
    );
  }

  GestureDetector buildPendingBookingTile(int index, num totalTravellers) {
    return GestureDetector(
        onTap: () =>
            controller.onTapSinglePendingBooking(controller.pendingList[index]),
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: Text(
                        controller.pendingList[index].tourCode ?? '',
                        style: paragraph2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('Tour date : ', style: paragraph4),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                        controller.pendingList[index].isCustom != true
                            ? 'group tour'
                            : 'custom tour',
                        style: paragraph2),
                    Text(
                        controller.getBookingDate(controller
                            .pendingList[index].dateOfTravel
                            .toString()),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.green.shade900,
                        )),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () => controller
              //           .onTapPendingTravellers(controller.pendingList[index]),
              //       child: Card(
              //         shape: const RoundedRectangleBorder( borderRadius: BorderRadius.only(
              //                   bottomLeft: Radius.circular(18),
              //                   bottomRight: Radius.circular(18),
              //                   topRight: Radius.circular(18),
              //                 ),),
              //                                           color: englishViolet,

              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             const Icon(
              //               TourMaker.people,
              //               color: Colors.white,
              //             ),
              //             const SizedBox(width: 4),
              //             Text(
              //               totalTravellers.toString(),
              //               style: const TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w800),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ));
  }

  Widget buildCompletedBookingTile(int index, num totalTravellers) {
    return GestureDetector(
        onTap: () => controller
            .onTapSingleCompletedBooking(controller.completedList[index]),
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            // height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: Text(
                          controller.completedList[index].tourCode ?? '',
                          style: paragraph2,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Paid Amount : ',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.green,
                          )),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                          controller.completedList[index].isCustom != true
                              ? 'group tour'
                              : 'custom tour',
                          style: paragraph2),
                      Text(
                          controller.completedList[index].amountPaid.toString(),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.green.shade900,
                          )),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () => controller.onTapCompleteddBookingTravellers(
                //       controller.completedList[index]),
                //   child: Column(
                //     children: <Widget>[
                //       Container(
                //         width: 76,
                //         height: 88,
                //         decoration: BoxDecoration(
                //           borderRadius: const BorderRadius.only(
                //             bottomLeft: Radius.circular(18),
                //             bottomRight: Radius.circular(18),
                //             topRight: Radius.circular(18),
                //           ),
                //           color: englishViolet,
                //         ),
                //         child: Center(
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               const Icon(
                //                 TourMaker.people,
                //                 color: Colors.white,
                //               ),
                //               const SizedBox(width: 4),
                //               Text(
                //                 totalTravellers.toString(),
                //                 style: const TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w800),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ));
  }

  Widget buildCancelledBookingTile(int index, num totalTravellers) {
    return GestureDetector(
        onTap: () => controller
            .onTapSingleCancelledBooking(controller.cancelledList[index]),
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            // height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: Text(
                          controller.cancelledList[index].tourCode ?? '',
                          style: paragraph2,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Tour Date : ',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                          controller.getBookingDate(controller
                              .cancelledList[index].dateOfTravel
                              .toString()),
                          style: paragraph2),
                      Text(
                          controller.cancelledList[index].payableAmount
                              .toString(),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () => controller.onTapCancelledBookingTravellers(
                //       controller.cancelledList[index]),
                //   child: Column(
                //     children: <Widget>[
                //       Container(
                //         width: 76,
                //         height: 88,
                //         decoration: BoxDecoration(
                //           borderRadius: const BorderRadius.only(
                //             bottomLeft: Radius.circular(18),
                //             bottomRight: Radius.circular(18),
                //             topRight: Radius.circular(18),
                //           ),
                //           color: englishViolet,
                //         ),
                //         child: Center(
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               const Icon(
                //                 TourMaker.people,
                //                 color: Colors.white,
                //               ),
                //               const SizedBox(width: 4),
                //               Text(
                //                 totalTravellers.toString(),
                //                 style: const TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w800),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}
