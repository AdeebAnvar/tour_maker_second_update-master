import 'package:get/get.dart';

import '../controllers/single_category_controller.dart';

class SingleCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingleCategoryController>(
      () => SingleCategoryController(),
    );
  }
}
