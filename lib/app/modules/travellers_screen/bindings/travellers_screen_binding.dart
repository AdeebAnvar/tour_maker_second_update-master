import 'package:get/get.dart';

import '../controllers/travellers_screen_controller.dart';

class TravellersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravellersScreenController>(
      () => TravellersScreenController(),
    );
  }
}
