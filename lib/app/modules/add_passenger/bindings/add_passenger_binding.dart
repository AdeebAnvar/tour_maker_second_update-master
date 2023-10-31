import 'package:get/get.dart';

import '../controllers/add_passenger_controller.dart';

class AddPassengerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPassengerController>(
      () => AddPassengerController(),
    );
  }
}
