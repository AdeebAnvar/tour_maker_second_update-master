import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../services/network_services/dio_client.dart';
import '../../models/network_models/tour_type_model.dart';

class TourTypeRepo {
  final Dio dio = Client().init();
  // List<SingleTourTypeModel> tourType = <SingleTourTypeModel>[];
  // List<TourTypesModel> tourType = <TourTypesModel>[];
  // Future<ApiResponse<List<SingleTourTypeModel>>> getSingleTourType(
  //     String tourTypeName) async {
  //   log('Tour Type');
  //   try {
  //     final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
  //     final Response<dynamic> res = await dio.getUri(
  //         Uri.parse('tours?tour_type=$tourTypeName'),
  //         options: Options(headers: authHeader));
  //     if (res.statusCode == 200) {
  //       tourType = (res.data['result'] as List<dynamic>).map(
  //         (dynamic e) {
  //           return SingleTourTypeModel.fromJson(e as Map<String, dynamic>);
  //         },
  //       ).toList();

  //       return ApiResponse<List<SingleTourTypeModel>>.completed(tourType);
  //     } else {
  //       return ApiResponse<List<SingleTourTypeModel>>.error(res.statusMessage);
  //     }
  //   } on DioException catch (de) {
  //     return ApiResponse<List<SingleTourTypeModel>>.error(de.toString());
  //   } catch (e) {
  //     return ApiResponse<List<SingleTourTypeModel>>.error(e.toString());
  //   }
  // }

  // Future<ApiResponse<List<TourTypesModel>>> getAllTourTypes() async {
  //   log('Tours Type');

  //   try {
  //     final Map<String, dynamic>? authHeader = await Client().getAuthHeader();
  //     final Response<dynamic> res = await dio.getUri(
  //         Uri.parse('tours/tourtype'),
  //         options: Options(headers: authHeader));
  //     if (res.statusCode == 200) {
  //       tourType = (res.data['result'] as List<dynamic>).map(
  //         (dynamic e) {
  //           return TourTypesModel.fromJson(e as Map<String, dynamic>);
  //         },
  //       ).toList();

  //       return ApiResponse<List<TourTypesModel>>.completed(tourType);
  //     } else {
  //       return ApiResponse<List<TourTypesModel>>.error(res.statusMessage);
  //     }
  //   } on DioException catch (de) {
  //     return ApiResponse<List<TourTypesModel>>.error(de.toString());
  //   } catch (e) {
  //     return ApiResponse<List<TourTypesModel>>.error(e.toString());
  //   }
  // }
}
