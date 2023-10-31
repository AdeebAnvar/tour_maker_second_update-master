import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/payment_summary_controller.dart';

class PaymentSummaryView extends GetView<PaymentSummaryController> {
  const PaymentSummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: Text('Payment Summary'),
        ),
        body: controller.obx(
          onEmpty: const CustomErrorScreen(errorText: 'Nothing found....'),
          onLoading: const CustomLoadingScreen(),
          (PaymentSummaryView? state) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView(
              children: <Widget>[
                Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    // height: 193,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                      controller.paymentList[0].tourName
                                          .toString(),
                                      style: subheading3),
                                  const SizedBox(height: 2),
                                  Text(
                                      controller.paymentList[0].tourCode
                                          .toString(),
                                      style: paragraph4),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Column(
                                children: <Widget>[
                                  Text('Booked Date', style: subheading3),
                                  const SizedBox(height: 2),
                                  Text(
                                      controller.paymentList[0].createdAt
                                          .toString()
                                          .parseFromIsoDate()
                                          .toDateTime(),
                                      style: paragraph4),
                                ],
                              ),
                              const SizedBox(height: 3),
                              if (controller.paymentList[0].orderConfirmed !=
                                  '')
                                Column(
                                  children: <Widget>[
                                    Text('Order confirmed on',
                                        style: subheading3.copyWith(
                                            color: Colors.green)),
                                    const SizedBox(height: 2),
                                    Text(
                                      controller.paymentList[0].orderConfirmed
                                          .toString()
                                          .parseFromIsoDate()
                                          .toDateTime(),
                                      style: paragraph4.copyWith(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 3),
                              Column(
                                children: <Widget>[
                                  Text('Tour Date', style: subheading3),
                                  const SizedBox(height: 2),
                                  Text(
                                      controller.paymentList[0].dateOfTravel
                                          .toString()
                                          .parseFromIsoDate()
                                          .toDate(),
                                      style: paragraph4),
                                  const SizedBox(height: 40),
                                  Text('Enquiry Type', style: subheading3),
                                  const SizedBox(height: 10),
                                  Text(
                                      controller.paymentList[0].isCustom != true
                                          ? 'Group Tour Enquiry'
                                          : 'Custom Tour Enquiry',
                                      style: paragraph4),
                                  const SizedBox(height: 20),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        // GestureDetector(
                        //   onTap: () => controller
                        //       .onClickPassengers(controller.paymentList[0].id),
                        //   child: Column(
                        //     children: <Widget>[
                        //       Container(
                        //         width: 73,
                        //         height: 65,
                        //         decoration: BoxDecoration(
                        //           borderRadius: const BorderRadius.only(
                        //             bottomLeft: Radius.circular(40),
                        //             topRight: Radius.circular(40),
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
                        //                 controller
                        //                     .getTotalTravellersCount()
                        //                     .toString(),
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
                ),
                Container(
                  width: 80.w,
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: englishViolet,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Type',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          )),
                      const VerticalDivider(color: Colors.white),
                      Text(
                        'Amount',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    width: 100.w,
                    padding: const EdgeInsets.symmetric(
                        vertical: 22, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Package Amount     :', style: subheading2),
                            Text('₹ ${controller.paymentList[0].totalAmount}',
                                style: subheading2),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (controller.paymentList[0].reward != 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Discount      :',
                                style: subheading2.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                              Text(controller.paymentList[0].reward.toString(),
                                  style: subheading2.copyWith(
                                      color: Colors.green)),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('GST (${controller.paymentList[0].gst}%):',
                                style: subheading2),
                            Text(
                                '₹ ${controller.getPackageGSTamount(controller.paymentList[0].totalAmount!, controller.paymentList[0].gst!)}',
                                style: subheading2),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Total Amount      :', style: subheading2),
                            Text('₹ ${controller.paymentList[0].payableAmount}',
                                style: subheading2),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // const SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: const <Widget>[
                        //     Text('Grand Total     :'),
                        //     Text('500'),
                        //   ],
                        // ),
                        // const SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     const Text('Payable Amount         :'),
                        //     Text(controller.paymentList[0].payableAmount
                        //         .toString()),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Paid Amount     :', style: subheading2),
                            Text(
                                controller.paymentList[0].amountPaid.toString(),
                                style: subheading2),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (controller.paymentList[0].payableAmount !=
                            controller.paymentList[0].amountPaid)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Remaining Amount     :',
                                style: subheading2.copyWith(color: Colors.red),
                              ),
                              Text(
                                controller.getRemainingAmount().toString(),
                                style: subheading2.copyWith(color: Colors.red),
                              ),
                            ],
                          ),
                        const SizedBox(height: 25),
                        // ActionChip(
                        //   label: Text(
                        //     'Get the Invoice',
                        //     style: paragraph4.copyWith(
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // onPressed: () => controller.invoicePdf(),
                        // await controller.generateInvoicePDF(
                        //   amountPaid: controller.paymentList[0].amountPaid!,
                        //   bookedDate: controller.paymentList[0].createdAt!,
                        //   totalAmount:
                        //       controller.paymentList[0].payableAmount!,
                        //   dateOfTravel:
                        //       controller.paymentList[0].dateOfTravel!,
                        //   gstAmount: controller.paymentList[0].gstAmount!,
                        //   gstPercentage: controller.paymentList[0].gst!,
                        //   packageAmount:
                        //       controller.paymentList[0].totalAmount!,
                        //   remainingAmount: controller.getRemainingAmount(),
                        //   tourCode: controller.paymentList[0].tourCode!,
                        //   tourName: controller.paymentList[0].tourName!,
                        //   adults: controller.paymentList[0].noOfAdults!,
                        //   kids: controller.paymentList[0].noOfKids!,
                        // );

                        // final String pdfPath = await controller.savePdf();

                        // final Directory documentDirectory =
                        //     await getApplicationDocumentsDirectory();
                        // final String documentPath = documentDirectory.path;

                        // // Set the base filename
                        // String filename = 'TourMakerInvoice.pdf';

                        // // Check if the file already exists
                        // File file = File('$documentPath/$filename');
                        // int suffix = 2;
                        // while (await file.exists()) {
                        //   // If the file exists, increment the suffix and try again
                        //   filename = 'TourMakerInvoice$suffix.pdf';
                        //   file = File('$documentPath/$filename');
                        //   suffix++;
                        // }
                        // final String fullPath =
                        //     '$documentPath/$filename.pdf';
                        //   log(pdfPath);
                        //   Get.toNamed(Routes.INVOICE_PDF,
                        //           arguments: [pdfPath])!
                        //       .whenComplete(() => controller.loadData());
                        // },
                        // backgroundColor: englishlinearViolet,
                        // ),

                        const SizedBox(height: 5),
                        if (controller.paymentList[0].payableAmount !=
                            controller.paymentList[0].amountPaid)
                          Obx(() {
                            return CustomButton().showButtonWithGradient(
                              isLoading: controller.isLoading.value,
                              text: 'Pay Remaining Amount',
                              onPressed: () =>
                                  controller.onClickPayRemainingAmount(
                                      controller.paymentList[0].id!),
                            );
                          }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
