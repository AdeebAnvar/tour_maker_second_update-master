import 'package:get/get.dart';

import '../controllers/exclusive_tours_controller.dart';

class ExclusiveToursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExclusiveToursController>(
      () => ExclusiveToursController(),
    );
  }
}
