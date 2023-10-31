import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/local_model/recent_search_mode.dart';
import '../../../data/models/network_models/package_model.dart';
import '../../../data/repo/network_repo/packages_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/search_view_view.dart';

class SearchViewController extends GetxController
    with StateMixin<SearchViewView> {
  final TextEditingController textController = TextEditingController();
  final RxList<RecentSearch> recentSearchesList = <RecentSearch>[].obs;
  final List<RecentSearch> recentSearches = <RecentSearch>[];
  RxList<PackageModel> packagesList = <PackageModel>[].obs;
  List<PackageModel> packages = <PackageModel>[].obs;
  RxString searchValue = ''.obs;
  final GetStorage storage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    await loadRecentSearchesFromStorage();
    await getPackages();
    change(null, status: RxStatus.success());
  }

  @override
  void onClose() {
    super.onClose();
    textController.dispose();
  }

  Future<void> onSubmitSearch(String value) async {
    if (value != null || value.isNotEmpty) {
      searchValue.value = value;
      final RecentSearch search =
          RecentSearch(keyword: searchValue.value.trim());
      final int existingIndex = recentSearchesList
          .indexWhere((RecentSearch s) => s.keyword == search.keyword);
      if (existingIndex >= 0) {
        // Move the existing search to the top of the list
        recentSearchesList.removeAt(existingIndex);
        recentSearchesList.insert(0, search);
      } else {
        // Add the new search to the top of the list
        recentSearchesList.insert(0, search);
      }
      storage.write(
          'recentSearches',
          recentSearchesList
              .map((RecentSearch search) => search.toJson())
              .toList());

      await Get.toNamed(Routes.SEARCH_DETAILS,
              arguments: searchValue.value.trim())!
          .whenComplete(() => loadRecentSearchesFromStorage());
    } else {
      Get.snackbar('Please enter a destination', '',
          backgroundColor: englishViolet, colorText: Colors.white);
    }
  }

  Future<void> getPackages() async {
    final ApiResponse<List<PackageModel>> res =
        await PackagesRepository().getAllPackages(0);
    if (res.data != null) {
      packages = res.data!;
      packagesList.value = res.data!;
    }
  }

  Future<void> loadRecentSearchesFromStorage() async {
    change(null, status: RxStatus.loading());
    final List<dynamic>? recentSearchesJson =
        storage.read('recentSearches') as List<dynamic>?;
    if (recentSearchesJson != null) {
      recentSearchesList.assignAll(recentSearchesJson
          .map((dynamic json) =>
              RecentSearch.fromJson(json as Map<String, dynamic>))
          .toList());
      recentSearches.assignAll(recentSearchesJson
          .map((dynamic json) =>
              RecentSearch.fromJson(json as Map<String, dynamic>))
          .toList());
    }
    change(null, status: RxStatus.success());
  }

  void onClickBack() {
    Get.toNamed(Routes.HOME)!
        .whenComplete(() => loadRecentSearchesFromStorage());
  }

  void onClickClearTextfIeld() => textController.clear();

  void onClickDeleteSuggestion(int index) {
    recentSearchesList.removeAt(index);
    storage.write('recentSearches', recentSearchesList.toList(growable: false));
  }

  void onSerchTextChanged(String text) {
    if (text.isNotEmpty) {
      packagesList.value = packages
          .where((PackageModel package) =>
              package.name!.toLowerCase().contains(text.toLowerCase()))
          .toList();
      recentSearchesList.value = recentSearches
          .where((RecentSearch recentSearch) =>
              recentSearch.keyword.toLowerCase().contains(text.toLowerCase()))
          .toList();
    } else {
      packagesList.value = packages;
      recentSearchesList.value = recentSearches;
    }
  }
}
