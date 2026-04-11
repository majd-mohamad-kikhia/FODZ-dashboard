import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/category_sections/data/models/category_section_response.dart';

enum CategorySectionType { restaurants, homeProducers, neama }

extension CategorySectionTypeConverter on CategorySectionType {
  static CategorySectionType fromDashboardScreen(DashboardScreen screen) {
    switch (screen) {
      case DashboardScreen.restaurants:
        return CategorySectionType.restaurants;
      case DashboardScreen.homeProducers:
        return CategorySectionType.homeProducers;
      case DashboardScreen.neama:
        return CategorySectionType.neama;
    }
  }
}

class CategorySectionsClient {
  final NetworkServices _net;

  CategorySectionsClient(this._net);

  Future<Either<AppException, CategorySectionResponse>>
      getCategorySection({
    required CategorySectionType sectionType,
    required int page,
  }) async {
    try {
      final String endpoint = _getEndpointForType(sectionType);

      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: '$endpoint?page=$page&limit=20',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final response = CategorySectionResponse.fromJson(data);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch category section');
    }
  }

  String _getEndpointForType(CategorySectionType type) {
    switch (type) {
      case CategorySectionType.restaurants:
        return EndPoints.getCatSectoinForRestaurant;
      case CategorySectionType.homeProducers:
        return EndPoints.getCatSectoinForHome;
      case CategorySectionType.neama:
        return EndPoints.getCatSectoinForNaema;
    }
  }
}
