import 'package:get/get.dart';

import '../controllers/single_destination_controller.dart';

class SingleDestinationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingleDestinationController>(
      () => SingleDestinationController(),
    );
  }
}
