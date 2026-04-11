import 'package:dio/dio.dart';

class RemoteDataBundle {
  final String networkPath;

  dynamic body;

  Map<String, dynamic>? urlParams;

  final FormData? data;

  RemoteDataBundle({
    required this.networkPath,
    this.data,
    this.body,
    this.urlParams,
  });
}

abstract class IRemoteDataSource {
  Future<dynamic> get(RemoteDataBundle remoteBundle);
  Future<dynamic> coustomGet(RemoteDataBundle remoteBundle);
  Future<dynamic> post(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
    Map<String, String>? extraHeaders,
  });
  Future<dynamic> coustomPost(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
    Map<String, String>? extraHeaders,
  });
  Future<dynamic> postFormData(RemoteDataBundle remoteBundle);
  Future<dynamic> customPostFormData(RemoteDataBundle remoteBundle);
  Future<dynamic> put(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  });
  Future<dynamic> customPut(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  });
  Future<dynamic> delete(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  });
  Future<dynamic> customDelete(
    RemoteDataBundle remoteBundle, {
    BaseOptions? baseOptions,
  });
}
