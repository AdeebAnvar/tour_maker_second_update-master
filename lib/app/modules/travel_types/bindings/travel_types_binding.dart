import 'package:get/get.dart';

import '../controllers/travel_types_controller.dart';

class TravelTypesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelTypesController>(
      () => TravelTypesController(),
    );
  }
}
