import 'package:get/get.dart';

import '../controllers/single_tour_controller.dart';

class SingleTourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingleTourController>(
      () => SingleTourController(),
    );
  }
}
