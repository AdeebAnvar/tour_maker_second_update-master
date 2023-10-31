import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/package_model.dart';

class PackagesRepository {
  final Dio dio = Client().init();
  List<PackageModel> packageList = <PackageModel>[];
  Future<ApiResponse<List<PackageModel>>> getAllPackages(int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<dynamic> res = await dio.getUri(
          Uri.parse('tours/packages?page=$page'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        packageList = (res.data['result'] as List<dynamic>).map(
          (dynamic e) {
            return PackageModel.fromJson(e as Map<String, dynamic>);
          },
        ).toList();

        return ApiResponse<List<PackageModel>>.completed(packageList);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getAllPackagesByDestination(
      dynamic destination, int page) async {
    try {
      final Map<String, dynamic>? authorHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.get(
          'tours/packages?destination=$destination&&page=page',
          options: Options(headers: authorHeader));

      if (res.statusCode == 200) {
        packageList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(packageList);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getCategorybycategoryName(
      dynamic categoryname, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> response = await dio.getUri(
          Uri.parse('tours/packages?category=$categoryname&page=$page'),
          options: Options(headers: authHeader));
      log('ghdsyhsyb ${response.data}');
      if (response.statusCode == 200) {
        if (response.data!['result'] != null) {
          packageList =
              (response.data!['result'] as List<dynamic>).map((dynamic e) {
            return PackageModel.fromJson(e as Map<String, dynamic>);
          }).toList();
        }

        return ApiResponse<List<PackageModel>>.completed(packageList);
      } else {
        return ApiResponse<List<PackageModel>>.error(response.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getAllSingleExclusiveTours(
      String destination, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/packages?exclusive=$destination&page=$page'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        packageList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(packageList);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getSingleTravelTypesTours(
      String name, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/packages?travel_type=$name&page=$page'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        packageList = (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(packageList);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }

  Future<ApiResponse<List<PackageModel>>> getSingleTrendingTours(
      String name, int page) async {
    try {
      final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
      final Response<Map<String, dynamic>> res = await dio.getUri(
          Uri.parse('tours/trending?destination=$name&page=$page'),
          options: Options(headers: authHeader));
      if (res.statusCode == 200) {
        final List<PackageModel> singleTour =
            (res.data!['result'] as List<dynamic>).map((dynamic e) {
          return PackageModel.fromJson(e as Map<String, dynamic>);
        }).toList();
        return ApiResponse<List<PackageModel>>.completed(singleTour);
      } else {
        return ApiResponse<List<PackageModel>>.error(res.statusMessage);
      }
    } on DioException catch (de) {
      return ApiResponse<List<PackageModel>>.error(de.error.toString());
    } catch (e) {
      return ApiResponse<List<PackageModel>>.error(e.toString());
    }
  }
}
