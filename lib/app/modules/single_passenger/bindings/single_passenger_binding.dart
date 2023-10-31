import 'package:get/get.dart';

import '../controllers/single_passenger_controller.dart';

class SinglePassengerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SinglePassengerController>(
      () => SinglePassengerController(),
    );
  }
}
