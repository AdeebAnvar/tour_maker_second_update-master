import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/style.dart';
import '../../../core/tour_maker_icons.dart';
import '../../widgets/images.dart';

Future<dynamic> showContactDialogue(
        {required String currentUserCategory,
        void Function()? onTapWhatsapp,
        void Function()? onTappCall}) =>
    Get.bottomSheet(
      enterBottomSheetDuration: const Duration(milliseconds: 600),
      exitBottomSheetDuration: const Duration(milliseconds: 600),
      isDismissible: true,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 22),
          child: SizedBox(
            // height: 42.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Contact US',
                  style: heading3,
                ),
                const SizedBox(height: 30),
                Text(
                  'Reach out TourMaker...',
                  style: paragraph3,
                ),
                const SizedBox(height: 30),
                if (onTapWhatsapp != null)
                  GestureDetector(
                    onTap: onTapWhatsapp,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SvgPicture.asset(whatsappImage,
                              height: 40, width: 40),
                          Text('Chat on Whatsapp', style: heading3)
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                const SizedBox(height: 30),
                if (currentUserCategory != 'standard')
                  onTappCall != null
                      ? GestureDetector(
                          onTap: onTappCall,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                const Icon(TourMaker.call),
                                Text('Call to our Customer Care',
                                    style: heading3)
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()
                else
                  const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
