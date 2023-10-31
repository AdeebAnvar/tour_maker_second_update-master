import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/category_model.dart';
import '../../models/network_models/exclusivetour_model.dart';
import '../../models/network_models/model.dart';
import '../../models/network_models/tour_type_model.dart';

class MainScreenServices {
  static Future<List<CategoriesAPIResult>> getAllCategory() async {
    try {
      // final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      // final GetStorage storage = GetStorage();
      // final String token = storage.read('token');
      final Dio client = Client().init();
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response res = await client.get('tours/categories',
          options: Options(headers: authHeader));
      final CategoryModel categories = CategoryModel.fromJson(res.data);
      return categories.result!;
    } catch (e) {
      return <CategoriesAPIResult>[];
    }
  }

  static Future<List<TourResult>?> getAllTrendingTours() async {
    // final String token = await storage.read('token');
    try {
      final Dio client = Client().init();
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response res = await client.get('tours/trending',
          options: Options(headers: authHeader));
      print(res.data.toString());
      print(res.statusCode);

      final TrendingToursModels toursModels =
          TrendingToursModels.fromJson(res.data);
      print('result');
      print('$toursModels ======================kkk');
      return toursModels.result;
    } catch (e) {
      print('$e    ========error');
      return <TourResult>[];
    }
  }
  // tours/exclusive

  static Future<List<Exclusive>?> getExclusiveTourss() async {
    // final String token = await storage.read('token');
    try {
      final Dio client = Client().init();
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response res = await client.get('tours/exclusive',
          options: Options(headers: authHeader));
      print(res.data.toString());
      print(res.statusCode);

      final ExclusiveToursModels toursModels =
          ExclusiveToursModels.fromJson(res.data);
      print('result');
      print('$toursModels ======================kkk');
      return toursModels.result;
    } catch (e) {
      print('${e.toString()}    ========error');
      return <Exclusive>[];
    }
  }

  static Future<List<TravelType>?> fetchTravelType() async {
    // final String token = await storage.read('token');
    // print(token);
    try {
      final Dio client = Client().init();
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response res = await client.get('tours/traveltypes',
          options: Options(headers: authHeader));
      print(res.data.toString());
      print(res.statusCode);

      final TravelTypesModelS traveltypes =
          TravelTypesModelS.fromJson(res.data);
      print('result');
      print('$traveltypes ======================kkk');
      return traveltypes.result;
    } catch (e) {
      print('${e.toString()}    ========error');
      return <TravelType>[];
    }
  }

  static Future<List<TourTypeResult>> fetchTourType() async {
    try {
      // final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      // final GetStorage storage = GetStorage();
      // final String token = storage.read('token');
      final Dio client = Client().init();
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();

      final Response res = await client.get('tours/tourtype',
          options: Options(headers: authHeader));
      final TourTypeModel tourtypes = TourTypeModel.fromJson(res.data);
      return tourtypes.result!;
    } catch (e) {
      return <TourTypeResult>[];
    }
  }
}
