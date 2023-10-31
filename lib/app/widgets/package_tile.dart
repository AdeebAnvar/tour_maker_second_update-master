import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';
import 'custom_cached_network_image.dart';

class PackageTile extends StatelessWidget {
  const PackageTile({
    super.key,
    required this.onPressed,
    required this.isFavourite,
    required this.onClickedFavourites,
    required this.tourName,
    required this.tourCode,
    required this.tourDays,
    required this.tournights,
    required this.tourAmount,
    required this.tourImage,
    required this.userType,
    this.brandName,
  });
  final String tourName;
  final String tourCode;
  final String tourDays;
  final String tournights;
  final String tourAmount;
  final String tourImage;
  final Function() onPressed;
  final bool isFavourite;
  final Function() onClickedFavourites;
  final String userType;
  final String? brandName;
  @override
  Widget build(BuildContext context) {
    int tourPrice = int.parse(tourAmount);
    String packageAmount = tourPrice < 10 ? '' : tourAmount;
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        child: Card(
          margin:
              const EdgeInsets.only(top: 10, bottom: 2, left: 10, right: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomCachedNetworkImage(
                          imageUrl: tourImage,
                          containerWidth: 130,
                          containerHeight: 150,
                          shimmerWidth: 125,
                          shimmerHeight: 125,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              width: 20.h,
                              child: Text(
                                tourName.trim(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: fontColor,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            if (userType != 'demo')
                              GestureDetector(
                                onTap: onClickedFavourites,
                                child: isFavourite
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 20.sp,
                                      )
                                    : Icon(
                                        Icons.favorite_border_outlined,
                                        color: englishlinearViolet,
                                        size: 20.sp,
                                      ),
                              ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(brandName ?? '', style: paragraph3),
                        const SizedBox(height: 7),
                        Text(tourCode, style: paragraph1),
                        const SizedBox(height: 3),
                        Text(
                          '$tourDays Days / $tournights Nights',
                          style: subheading3,
                        ),
                        if (tourPrice > 10)
                          Text(
                            '₹ $packageAmount',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: fontColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
