import 'package:get/get.dart';

import '../controllers/lucky_draw_controller.dart';

class LuckyDrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LuckyDrawController>(
      () => LuckyDrawController(),
    );
  }
}
