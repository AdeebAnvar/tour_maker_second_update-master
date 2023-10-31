import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_cached_network_image.dart';
import '../controllers/token_screen_controller.dart';

class TokenScreenView extends GetView<TokenScreenController> {
  const TokenScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final TokenScreenController controller = Get.put(TokenScreenController());
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then(
                      (dynamic value) => Get.offAllNamed(Routes.GET_STARTED));
                },
                icon: const Icon(Icons.logout))
          ],
          title: const Text('TestView'),
          centerTitle: true,
        ),
        body: controller.obx(
          (TokenScreenView? state) => Obx(() => controller.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: controller.result.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    leading: CustomCachedNetworkImage(
                        shimmerHeight: 20,
                        containerHeight: 20,
                        containerWidth: 20,
                        shimmerWidth: 30,
                        borderRadius: BorderRadius.circular(10),
                        imageUrl: controller.result[index].image.toString()),
                  ),
                )),
        ));
  }

  Center buildTokenView(TokenScreenController controller) {
    return Center(
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        padding: const EdgeInsets.all(28.0),
        margin: const EdgeInsets.all(28.0),
        child: TextFormField(
          keyboardType: TextInputType.streetAddress,
          maxLines: 100,
          initialValue: controller.tok.toString(),
          onChanged: (String value) => controller.tok = value,
        ),
      ),
    );
  }

  Center buildFCMTokenView(TokenScreenController controller) {
    return Center(
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        padding: const EdgeInsets.all(28.0),
        margin: const EdgeInsets.all(28.0),
        child: TextFormField(
          keyboardType: TextInputType.streetAddress,
          maxLines: 100,
          initialValue: controller.fcmtok.toString(),
          onChanged: (String value) => controller.fcmtok = value,
        ),
      ),
    );
  }
}
