import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/cities/data/models/city_model.dart';

class CitiesClient {
  final NetworkServices _net = NetworkServices();

  Future<Either<AppException, List<CityModel>>> fetchCities() async {
    try {
      final res = await _net.coustomGet(
        RemoteDataBundle(networkPath: EndPoints.getCities),
      );
      return res.fold(
        (error) => Left(error),
        (data) {
          final list = data['cities'] as List<dynamic>;
          return Right(list.map((e) => CityModel.fromJson(e)).toList());
        },
      );
    } catch (e) {
      return Left(ServerException(msg: 'فشل في تحميل المدن'));
    }
  }

  Future<Either<AppException, CityModel>> createCity({
    required String name,
    required String nameAr,
  }) async {
    try {
      final res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.createCity,
          body: {'name': name, 'nameAr': nameAr},
        ),
      );
      return res.fold(
        (error) => Left(error),
        (data) {
          final cityJson = data['city'] ?? data;
          return Right(CityModel.fromJson(cityJson));
        },
      );
    } catch (e) {
      return Left(ServerException(msg: 'فشل في إنشاء المدينة'));
    }
  }

  Future<Either<AppException, void>> deleteCity(int cityId) async {
    try {
      final res = await _net.customDelete(
        RemoteDataBundle(
          networkPath: EndPoints.deleteCity + cityId.toString(),
        ),
      );
      return res.fold(
        (error) => Left(error),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(ServerException(msg: 'فشل في حذف المدينة'));
    }
  }
}
