import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/network_models/user_model.dart';
import '../../../data/repo/network_repo/user_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/lucky_draw_view.dart';

class LuckyDrawController extends GetxController
    with StateMixin<LuckyDrawView> {
  dynamic userName;
  String? currentUserName;
  final RxInt count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isloading = false.obs;
  RxBool isClickNext = false.obs;

  final GetStorage getStorage = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    change(null, status: RxStatus.success());
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  void onClickDemoApp() {
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> onClickFoatingButton() async {
    CustomDialog().showCustomDialog(
      barrierDismissible: false,
      'Want to Suggest A Friend',
      confirmText: 'NO',
      cancelText: 'Suggest',
      onCancel: () async {
        Get.back();
        Get.offAllNamed(Routes.SUGGEST_FRIEND);
      },
      onConfirm: () {
        Get.offAllNamed(Routes.HOME);
      },
    );
  }

  Future<void> onClickNext() async {
    isLoading.value = true;
    final GetStorage storage = GetStorage();
    // isClickNext.value = true;
    final ApiResponse<UserModel> res = await UserRepository().getUserDetails();
    if (res.data != null || res.status == ApiResponseStatus.completed) {
      final UserModel user = res.data!;
      await storage.write('customer_Id', user.customerId);
      await Get.offAllNamed(Routes.HOME);
    }
  }
}
