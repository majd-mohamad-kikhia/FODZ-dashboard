import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/product_sections/data/models/product_section_response.dart';

enum ProductSectionType { restaurants, homeProducers, neama }

extension ProductSectionTypeConverter on ProductSectionType {
  static ProductSectionType fromDashboardScreen(DashboardScreen screen) {
    switch (screen) {
      case DashboardScreen.restaurants:
        return ProductSectionType.restaurants;
      case DashboardScreen.homeProducers:
        return ProductSectionType.homeProducers;
      case DashboardScreen.neama:
        return ProductSectionType.neama;
    }
  }
}

class ProductSectionsClient {
  final NetworkServices _net;

  ProductSectionsClient(this._net);

  Future<Either<AppException, ProductSectionResponse>>
      getProductSection({
    required ProductSectionType sectionType,
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
          final response = ProductSectionResponse.fromJson(data);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch product section');
    }
  }

  String _getEndpointForType(ProductSectionType type) {
    switch (type) {
      case ProductSectionType.restaurants:
        return EndPoints.getProSectoinForRestaurant;
      case ProductSectionType.homeProducers:
        return EndPoints.getProSectoinForHome;
      case ProductSectionType.neama:
        return EndPoints.getProSectoinForNaema;
    }
  }
}
