import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../core/theme/style.dart';
import 'images.dart';

class CustomErrorScreen extends StatelessWidget {
  const CustomErrorScreen({super.key, required this.errorText, this.onRefresh});
  final String errorText;
  final Future<void> Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      color: Colors.transparent,
      animSpeedFactor: 3,
      springAnimationDurationInMilliseconds: 600,
      backgroundColor: englishViolet,
      onRefresh: onRefresh ?? () async {},
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 140),
                Image.asset(emptyImage),
                const SizedBox(height: 40),
                Text(
                  errorText,
                  style: subheading1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
