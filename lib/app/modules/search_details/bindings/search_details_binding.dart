import 'package:get/get.dart';

import '../controllers/search_details_controller.dart';

class SearchDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchDetailsController>(
      () => SearchDetailsController(),
    );
  }
}
