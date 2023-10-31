import 'package:get/get.dart';

import '../../../data/models/network_models/travellers_model.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/travellers_screen_view.dart';

class TravellersScreenController extends GetxController
    with StateMixin<TravellersScreenView> {
  RxList<TravellersModel> travellers = <TravellersModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      final int orderID = Get.arguments as int;
      final ApiResponse<List<TravellersModel>> res =
          await PassengerRepository().getAllPassengersByOrderId(orderID);
      if (res.data != null) {
        travellers.value = res.data!;
        change(null, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } else {
      change(null, status: RxStatus.error());
    }
  }

  void onTapSinglePassenger(int? id) {
    Get.toNamed(Routes.SINGLE_PASSENGER, arguments: id);
  }
}
