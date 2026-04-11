import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/category_sections/data/models/category_details_response.dart';

abstract class ICategoryDetailsClient {
  Future<Either<AppException, List<CategoryProduct>>> fetchCategoryProducts(int restaurantId, int categoryId);
}

class CategoryDetailsClientImpl implements ICategoryDetailsClient {
  final IRemoteDataSource _net;

  CategoryDetailsClientImpl(this._net);

  @override
  Future<Either<AppException, List<CategoryProduct>>> fetchCategoryProducts(int restaurantId, int categoryId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: 'product/$restaurantId/$categoryId',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final CategoryDetailsResponse response = 
              CategoryDetailsResponse.fromJson(data as Map<String, dynamic>);
          return Right(response.data);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'فشل في جلب المنتجات: ${e.toString()}');
    }
  }
}
