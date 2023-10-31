import 'package:get/get.dart';

import '../controllers/tours_view_controller.dart';

class ToursViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToursViewController>(
      () => ToursViewController(),
    );
  }
}
