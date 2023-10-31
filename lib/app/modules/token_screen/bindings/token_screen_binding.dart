import 'package:get/get.dart';

import '../controllers/token_screen_controller.dart';

class TokenScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenScreenController>(
      () => TokenScreenController(),
    );
  }
}
