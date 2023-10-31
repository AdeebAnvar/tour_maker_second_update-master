import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/style.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer(
      {super.key,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.borderRadius,
      this.shape = BoxShape.rectangle});
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      period: const Duration(seconds: 1),
      gradient: LinearGradient(
        colors: <Color>[
          Colors.grey.shade100,
          Colors.grey.shade300,
          Colors.grey.shade100,
        ],
      ),
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
      ),
    );
  }
}
