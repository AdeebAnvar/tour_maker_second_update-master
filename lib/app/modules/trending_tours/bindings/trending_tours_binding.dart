import 'package:get/get.dart';

import '../controllers/trending_tours_controller.dart';

class TrendingToursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrendingToursController>(
      () => TrendingToursController(),
    );
  }
}
