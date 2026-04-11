import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/restaurants/data/models/pending_restaurant_model.dart';
import 'package:foodzdashbord/features/restaurants/data/models/pending_restaurants_response_model.dart';

abstract class IPendingRestaurantsClient {
  Future<Either<AppException, List<PendingRestaurantModel>>> fetchPendingRestaurants();
  Future<Either<AppException, bool>> acceptRestaurant(int restaurantId);
  Future<Either<AppException, bool>> declineRestaurant(int restaurantId);
}

class PendingRestaurantsClientImpl implements IPendingRestaurantsClient {
  final IRemoteDataSource _net;

  PendingRestaurantsClientImpl(this._net);

  @override
  Future<Either<AppException, List<PendingRestaurantModel>>> fetchPendingRestaurants() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.listPendingRestaurants,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final PendingRestaurantsResponseModel response = 
              PendingRestaurantsResponseModel.fromJson(data as Map<String, dynamic>);
          return Right(response.restaurants);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'فشل في جلب المطاعم المعلقة: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, bool>> acceptRestaurant(int restaurantId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: '${EndPoints.acceptPendingResAndHome}$restaurantId',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'فشل في قبول المطعم: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, bool>> declineRestaurant(int restaurantId) async {
    try {
      final Either<AppException, dynamic> res = await _net.customPut(
        RemoteDataBundle(
          networkPath: '${EndPoints.declinePendingResAndHome}$restaurantId',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'فشل في رفض المطعم: ${e.toString()}');
    }
  }
}
