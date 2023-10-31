// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'custom_shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  CustomCachedNetworkImage({
    super.key,
    required this.shimmerHeight,
    required this.shimmerWidth,
    required this.containerHeight,
    required this.containerWidth,
    required this.imageUrl,
    this.containerShape = BoxShape.rectangle,
    this.borderRadius,
  });
  final double shimmerHeight;
  final double shimmerWidth;
  final double containerHeight;
  final double containerWidth;
  final String imageUrl;
  final BoxShape containerShape;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    log('Hii build widget');
    return CachedNetworkImage(
      key: UniqueKey(),
      cacheKey: UniqueKey().toString(),
      fadeInCurve: Curves.bounceInOut,
      placeholder: (BuildContext context, String url) {
        log('Hii placeHolder');
        return CustomShimmer(
          height: shimmerHeight,
          width: shimmerWidth,
          borderRadius: BorderRadius.circular(10),
        );
      },
      imageUrl: imageUrl,
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) {
        log('Hii error widget');
        return Container(
          padding: const EdgeInsets.all(10),
          height: containerHeight,
          width: containerWidth,
          decoration: BoxDecoration(
            shape: containerShape,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider,
            ),
            // color: Colors.grey,
            borderRadius: borderRadius,
          ),
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        log('Hii error widget $url');
        return Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(url),
            ),
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
