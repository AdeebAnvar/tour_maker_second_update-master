import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/category_model.dart';
import '../../../data/repo/network_repo/category_repo.dart';
import '../views/token_screen_view.dart';

class TokenScreenController extends GetxController
    with StateMixin<TokenScreenView> {
  String? tok;
  String? fcmtok;

  // late TabController tabController;

  GetStorage getstorage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    getResult().then((value) => result.value = value!);

    // loadData();
    // tabController = TabController(length: 2, vsync: this);
    change(null, status: RxStatus.success());
  }

  RxList<CategoriesAPIResult> result = <CategoriesAPIResult>[].obs;
  RxBool loading = true.obs;
  Future<List<CategoriesAPIResult>?> getResult() async {
    try {
      var data = await CategoryRepository.getAllCategory();
      loading.value = false;
      return data;
    } catch (e) {
      loading.value = false;
    }
    return null;
  }

  @override
  void onClose() {
    super.onClose();
    // tabController.dispose();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    // if (Get.arguments != null) {
    //   tok = Get.arguments[0] as String;
    //   fcmtok = Get.arguments[1] as String;
    //   await getstorage.write('fcmtok', fcmtok);
    change(null, status: RxStatus.success());
    // } else {
    //   tok = getstorage.read('token');
    //   fcmtok = getstorage.read('fcmtok');
    // }
  }
}
