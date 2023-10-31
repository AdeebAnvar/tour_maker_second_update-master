import 'package:get/get.dart';

import '../controllers/user_registerscreen_controller.dart';

class UserRegisterscreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRegisterscreenController>(
      () => UserRegisterscreenController(),
    );
  }
}
