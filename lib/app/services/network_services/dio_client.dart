import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../widgets/custom_dialogue.dart';
import 'dio_connnecticity_retryer.dart';

class Client {
  FirebaseAuth auth = FirebaseAuth.instance;

  GetStorage storage = GetStorage();
  Dio init({String baseUrl = 'https://api.tourmakerapp.com/'}) {
    final Dio dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        await auth.currentUser!.getIdToken(true).then((String? value) async {
          await storage.write('token', value);
        });
        log('messagerdvfc');
        handler.next(options);
      },
    ));
    // dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     maxWidth: 180,
    //   ),
    // );
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetryer: DioConnectivityRequestRetryer(
          connectivity: Connectivity(),
          dio: Dio(),
        ),
      ),
    );
    dio.options = BaseOptions(
        followRedirects: true,
        baseUrl: baseUrl,
        validateStatus: (int? status) {
          if (status != null) {
            return status < 500;
          } else {
            return false;
          }
        },
        contentType: 'application/json',
        headers: <String, dynamic>{});

    return dio;
  }

  Future<Map<String, dynamic>?> getAuthHeader() async {
    final dynamic tok = await storage.read('token');
    log(tok.toString());
    if (tok != null) {
      final Map<String, dynamic> header = <String, dynamic>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $tok',
      };

      return header;
    } else {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final User? currentUser = auth.currentUser;
      final String? token = await currentUser!.getIdToken(true);

      final Map<String, dynamic> header = <String, dynamic>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      return header;
    }
  }

  Future<Map<String, String>?> getMultiPartAuthHeader() async {
    final dynamic tok = await storage.read('token');
    if (tok != null) {
      final Map<String, String> header = <String, String>{
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $tok',
      };
      return header;
    } else {
      return null;
    }
  }
}

class ApiResponse<T> {
  ApiResponse.error(this.message) : status = ApiResponseStatus.error;
  ApiResponse.unProcessable(this.message)
      : status = ApiResponseStatus.unProcessable;
  ApiResponse.completed(this.data) : status = ApiResponseStatus.completed;
  ApiResponse.loading(this.message) : status = ApiResponseStatus.loading;
  ApiResponse.idle() : status = ApiResponseStatus.idle;
  ApiResponseStatus status;
  T? data;
  String? message;
  @override
  String toString() {
    return 'ApiResponseStatus : $status \n Message : $message \n Data : $data';
  }
}

enum ApiResponseStatus { idle, loading, completed, unProcessable, error }

class RetryOnConnectionChangeInterceptor extends Interceptor {
  RetryOnConnectionChangeInterceptor({required this.requestRetryer});

  final DioConnectivityRequestRetryer requestRetryer;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        handler.next((await requestRetryer
            .scheduleRequestRetry(err.requestOptions)) as DioException);
      } catch (e) {
        CustomDialog().showCustomDialog('Error !', contentText: e.toString());
        handler.next(e as DioException);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.unknown &&
        err.error != null &&
        err.error is SocketException;
  }
}
