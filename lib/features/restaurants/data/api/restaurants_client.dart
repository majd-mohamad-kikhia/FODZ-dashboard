import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';
import 'package:foodzdashbord/features/restaurants/data/models/restaurants_response_model.dart';

abstract class IRestaurantsClient {
  Future<Either<AppException, List<RestaurantModel>>> fetchRestaurants();
  Future<Either<AppException, String>> banRestaurant(int restaurantId);
  Future<Either<AppException, String>> unbanRestaurant(int restaurantId);
}

class RestaurantsClientImpl implements IRestaurantsClient {
  final IRemoteDataSource _net;

  RestaurantsClientImpl(this._net);

  @override
  Future<Either<AppException, List<RestaurantModel>>> fetchRestaurants() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.getRestaurant,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final RestaurantsResponseModel response = 
              RestaurantsResponseModel.fromJson(data as Map<String, dynamic>);
          return Right(response.restaurants);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch restaurants: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> banRestaurant(int restaurantId) async {
    try {
      final Either<AppException, dynamic> res = await _net.customPut(
        RemoteDataBundle(
          networkPath: '${EndPoints.banResOrHome}$restaurantId',
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) {
          final message = data['message'] as String? ?? 'تم حظر المطعم بنجاح';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to ban restaurant: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> unbanRestaurant(int restaurantId) async {
    try {
      final Either<AppException, dynamic> res = await _net.customPut(
        RemoteDataBundle(
          networkPath: '${EndPoints.unbanResOrHome}$restaurantId',
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) {
          final message = data['message'] as String? ?? 'تم إلغاء الحظر بنجاح';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to unban restaurant: ${e.toString()}');
    }
  }
}
