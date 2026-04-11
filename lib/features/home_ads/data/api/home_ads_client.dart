import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/home_ads/data/models/active_restaurant_model.dart';
import 'package:foodzdashbord/features/home_ads/data/models/home_ad_response.dart';

abstract class IHomeAdsClient {
  Future<Either<AppException, HomeAdResponse>> fetchHomeAds();
  Future<Either<AppException, ActiveRestaurantResponse>> fetchActiveRestaurants();
  Future<Either<AppException, dynamic>> createHomeAd({
    required int resId,
    String? imagePath,
    Uint8List? imageBytes,
    String? fileName,
  });
  Future<Either<AppException, dynamic>> deleteHomeAd(int adId);
}

class HomeAdsClientImpl implements IHomeAdsClient {
  final IRemoteDataSource _net;

  HomeAdsClientImpl(this._net);

  @override
  Future<Either<AppException, HomeAdResponse>> fetchHomeAds() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.getHomeAds,
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) {
          final response = HomeAdResponse.fromJson(data as Map<String, dynamic>);
          return Right(response);
        },
      );
    } catch (e) {
      return Left(ServerException(msg: 'Failed to fetch home ads: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, ActiveRestaurantResponse>> fetchActiveRestaurants() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.gitActiveRes,
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) {
          final response = ActiveRestaurantResponse.fromJson(data as Map<String, dynamic>);
          return Right(response);
        },
      );
    } catch (e) {
      return Left(ServerException(msg: 'Failed to fetch active restaurants: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, dynamic>> createHomeAd({
    required int resId,
    String? imagePath,
    Uint8List? imageBytes,
    String? fileName,
  }) async {
    try {
      MultipartFile imageFile;
      
      if (imageBytes != null) {
        // Web platform - use bytes
        imageFile = MultipartFile.fromBytes(
          imageBytes,
          filename: fileName ?? 'image.jpg',
        );
      } else if (imagePath != null) {
        // Native platform - use file path
        imageFile = await MultipartFile.fromFile(imagePath);
      } else {
        return Left(ServerException(msg: 'No image provided'));
      }

      FormData formData = FormData.fromMap({
        'resId': resId,
        'image': imageFile,
      });

      final Either<AppException, dynamic> res = await _net.postFormData(
        RemoteDataBundle(
          networkPath: EndPoints.createHomeAd,
          data: formData,
        ),
      );

      return res.fold<Either<AppException, dynamic>>(
        (error) => Left(error),
        (data) => Right({'success': true}),
      );
    } catch (e) {
      return Left(ServerException(msg: 'Failed to create home ad: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AppException, dynamic>> deleteHomeAd(int adId) async {
    try {
      final Either<AppException, dynamic> res = await _net.customDelete(
        RemoteDataBundle(
          networkPath: 'home-ads/delete?id=$adId',
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) => Right(data),
      );
    } catch (e) {
      return Left(ServerException(msg: 'Failed to delete home ad: ${e.toString()}'));
    }
  }
}
