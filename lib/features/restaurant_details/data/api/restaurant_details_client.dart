import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/restaurant_details/data/models/restaurant_details_response.dart';

abstract class IRestaurantDetailsClient {
  Future<Either<AppException, List<RestaurantCategory>>> fetchRestaurantCategories(int restaurantId);
}

class RestaurantDetailsClientImpl implements IRestaurantDetailsClient {
  final IRemoteDataSource _net;

  RestaurantDetailsClientImpl(this._net);

  @override
  Future<Either<AppException, List<RestaurantCategory>>> fetchRestaurantCategories(int restaurantId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: 'category/$restaurantId',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final RestaurantDetailsResponse response = 
              RestaurantDetailsResponse.fromJson(data as Map<String, dynamic>);
          return Right(response.categories);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'فشل في جلب الفئات: ${e.toString()}');
    }
  }
}
