import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/category_model.dart';
import '../../models/network_models/package_model.dart';

class CategoryRepository {
  List<CategoryModel> categoryList = <CategoryModel>[];
  List<PackageModel> singleCategoryList = <PackageModel>[];
  final Dio dio = Client().init();
  // Future<ApiResponse<List<CategoryModel>>> getAllCategory() async {
  //   try {
  //     final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
  //     final Response<Map<String, dynamic>> res = await dio.getUri(
  //         Uri.parse('tours/categories'),
  //         options: Options(headers: authHeader));
  //     if (res.statusCode == 200) {
  //       categoryList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
  //         return CategoryModel.fromJson(e as Map<String, dynamic>);
  //       }).toList();
  //       return ApiResponse<List<CategoryModel>>.completed(categoryList);
  //     } else {
  //       return ApiResponse<List<CategoryModel>>.error(res.statusMessage);
  //     }
  //   } on DioException catch (de) {
  //     return ApiResponse<List<CategoryModel>>.error(de.error.toString());
  //   } catch (e) {
  //     return ApiResponse<List<CategoryModel>>.error(e.toString());
  //   }
  // }
  static Future<List<CategoriesAPIResult>> getAllCategory() async {
    try {
      // final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      // final GetStorage storage = GetStorage();
      // final String token = storage.read('token');
      final Dio client = Client().init();
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final res = await client.get('tours/categories',
          options: Options(headers: authHeader));
      final CategoryModel categories = CategoryModel.fromJson(res.data);
      return categories.result!;
    } catch (e) {
      return <CategoriesAPIResult>[];
    }
  }
}
