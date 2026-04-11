import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/utils/app_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';

class NetworkServices implements IRemoteDataSource {
  NetworkServices._internal();

  static final NetworkServices _instance = NetworkServices._internal();

  factory NetworkServices() => _instance;

  static Map<String, dynamic> headers = Map<String, dynamic>.from(
    EndPoints.baseHeaders,
  );

  static Future<Map<String, dynamic>> initTokenAndHeaders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token =prefs.getString(AppStrings.token); //prefs.getString(AppStrings.token);
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      } else {
        headers.remove("Authorization");
      }
    } catch (_) {
      // ignore read errors; proceed without auth header
    }
    return headers;
  }

  @override
  Future get(RemoteDataBundle remoteBundle) async {
    try {
      BaseOptions options = BaseOptions(
        connectTimeout: const Duration(milliseconds: 30 * 1000),
        receiveTimeout: const Duration(milliseconds: 30 * 1000),
        sendTimeout: const Duration(milliseconds: 30 * 1000),
      );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);
      await initTokenAndHeaders();
      final Response response = await dio.get(
        EndPoints.baseUrl + remoteBundle.networkPath,
        options: Options(headers: headers, responseType: ResponseType.plain),
        queryParameters: remoteBundle.urlParams,
        data: remoteBundle.body,
      );

      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      exceptionHandling(e.response!);
    }
  }

  @override
  Future<Either<AppException, dynamic>> coustomGet(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
    Map<String, dynamic>? extraHeaders,
    String baseUrl = EndPoints.baseUrl,
  }) async {
    try {
      Map<String, dynamic> hh = {};
      await initTokenAndHeaders();
      hh.addAll(headers);
      if (extraHeaders != null) {
        hh.addAll(extraHeaders);
      }

      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 30 * 1000),
            receiveTimeout: const Duration(milliseconds: 30 * 1000),
            sendTimeout: const Duration(milliseconds: 30 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);

      final response = await dio.get(
        baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        queryParameters: remoteBundle.urlParams,
        options: Options(headers: hh, responseType: ResponseType.plain),
      );

      // return _handleResponseAsJson(response);
      return Right(_handleResponseAsJson(response));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return Left(ServerException(msg: 'حدث خطأ بالاتصال'));
      }
      if (e.response != null) {
        return Left(exceptionHandling(e.response!));
      }
      return Left(ServerException(msg: 'حدث خطأ بالاتصال'));
    }
  }

  @override
  Future post(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
    Map<String, dynamic>? extraHeaders,
    String baseUrl = EndPoints.baseUrl,
  }) async {
    try {
      await initTokenAndHeaders();
      if (extraHeaders != null) {
        headers.addAll(extraHeaders);
      }
      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 100 * 1000),
            receiveTimeout: const Duration(milliseconds: 100 * 1000),
            sendTimeout: const Duration(milliseconds: 100 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);

      final response = await dio.post(
        baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        queryParameters: remoteBundle.urlParams,
        options: Options(headers: headers, responseType: ResponseType.plain),
      );

      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      return exceptionHandling(e.response!);
    }
  }

  @override
  Future<Either<AppException, dynamic>> coustomPost(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
    Map<String, dynamic>? extraHeaders,
    String baseUrl = EndPoints.baseUrl,
  }) async {
    try {
      Map<String, dynamic> hh = {};
      await initTokenAndHeaders();
      hh.addAll(headers);
      if (extraHeaders != null) {
        hh.addAll(extraHeaders);
      }
      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 30 * 1000),
            receiveTimeout: const Duration(milliseconds: 30 * 1000),
            sendTimeout: const Duration(milliseconds: 30 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);

      final response = await dio.post(
        baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        queryParameters: remoteBundle.urlParams,
        options: Options(headers: hh, responseType: ResponseType.plain),
      );

      // return _handleResponseAsJson(response);
      return Right(_handleResponseAsJson(response));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return Left(ServerException(msg: 'حدث خطا بالشبكة'));
      }
      if (e.response != null) {
        return Left(exceptionHandling(e.response!));
      }
      return Left(ServerException(msg: 'حدث خطا بالشبكة'));
    }
  }

  @override
  Future postFormData(RemoteDataBundle remoteBundle) async {
    try {
      final formHeaders = Map<String, dynamic>.from(headers);
      var dio = Dio();
      prettyLoggerMethod(dio);
      final response = await dio.post(
        EndPoints.baseUrl + remoteBundle.networkPath,
        data: remoteBundle.data,
        options: Options(
          headers: formHeaders,
          responseType: ResponseType.plain,
        ),
      );

      return Right(_handleResponseAsJson(response));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return Left(ServerException(msg: 'حدث خطأ بالاتصال'));
      }
      if (e.response != null) {
        return Left(exceptionHandling(e.response!));
      }
      return Left(ServerException(msg: 'حدث خطأ بالاتصال'));
    }
  }

  @override
  Future customPostFormData(RemoteDataBundle remoteBundle) async {
    try {
      final formHeaders = Map<String, dynamic>.from(headers);
      var dio = Dio();
      prettyLoggerMethod(dio);
      final response = await dio.post(
        EndPoints.baseUrl + remoteBundle.networkPath,
        data: remoteBundle.data,
        options: Options(
          headers: formHeaders,
          responseType: ResponseType.plain,
        ),
      );

      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return ServerException(msg: 'حدث خطأ بالاتصال');
      }
      if (e.response != null) {
        return exceptionHandling(e.response!);
      }
      return ServerException(msg: 'حدث خطأ بالاتصال');
    }
  }

  @override
  Future put(RemoteDataBundle remoteBundle, {BaseOptions? baseOptions}) async {
    try {
      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 30 * 1000),
            receiveTimeout: const Duration(milliseconds: 30 * 1000),
            sendTimeout: const Duration(milliseconds: 30 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);

      final response = await dio.put(
        EndPoints.baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        options: Options(headers: headers, responseType: ResponseType.plain),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      exceptionHandling(e.response!);
    }
  }

  @override
  Future<Either<AppException, dynamic>> customPut(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  }) async {
    try {
      await initTokenAndHeaders();
      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 30 * 1000),
            receiveTimeout: const Duration(milliseconds: 30 * 1000),
            sendTimeout: const Duration(milliseconds: 30 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);

      final response = await dio.put(
        EndPoints.baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        options: Options(headers: headers, responseType: ResponseType.plain),
      );
      return Right(_handleResponseAsJson(response));
    } on DioException catch (e) {
      return Left(exceptionHandling(e.response!));
    }
  }

  @override
  Future delete(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  }) async {
    try {
      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 30 * 1000),
            receiveTimeout: const Duration(milliseconds: 30 * 1000),
            sendTimeout: const Duration(milliseconds: 30 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);
      await initTokenAndHeaders();
      final response = await dio.delete(
        EndPoints.baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        options: Options(headers: headers, responseType: ResponseType.plain),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      exceptionHandling(e.response!);
    }
  }

  @override
  Future<Either<AppException, dynamic>> customDelete(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  }) async {
    try {
      BaseOptions options =
          baseOptions ??
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 30 * 1000),
            receiveTimeout: const Duration(milliseconds: 30 * 1000),
            sendTimeout: const Duration(milliseconds: 30 * 1000),
          );
      Dio dio = Dio(options);
      prettyLoggerMethod(dio);
      await initTokenAndHeaders();
      final response = await dio.delete(
        EndPoints.baseUrl + remoteBundle.networkPath,
        data: remoteBundle.body,
        options: Options(headers: headers, responseType: ResponseType.plain),
      );
      return Right(_handleResponseAsJson(response));
    } on DioException catch (e) {
      return Left(exceptionHandling(e.response!));
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    if (kDebugMode) {
      print(response);
    }
    final responseJson = jsonDecode(response.data);
    print(responseJson);
    print('ssssssssssssssssssssssssssssssssssssss');
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  void prettyLoggerMethod(Dio dio) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}
