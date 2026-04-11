import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/models/restaurant_section_response.dart';

enum SectionType { restaurants, homeProducers, neama }

extension SectionTypeConverter on SectionType {
  static SectionType fromDashboardScreen(DashboardScreen screen) {
    switch (screen) {
      case DashboardScreen.restaurants:
        return SectionType.restaurants;
      case DashboardScreen.homeProducers:
        return SectionType.homeProducers;
      case DashboardScreen.neama:
        return SectionType.neama;
    }
  }
}

class RestaurantSectionsClient {
  final NetworkServices _net;

  RestaurantSectionsClient(this._net);

  Future<Either<AppException, RestaurantSectionResponse>>
      getRestaurantSection({
    required SectionType sectionType,
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
          final response = RestaurantSectionResponse.fromJson(data);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch restaurant section');
    }
  }

  String _getEndpointForType(SectionType type) {
    switch (type) {
      case SectionType.restaurants:
        return EndPoints.getResSectionForRestaurant;
      case SectionType.homeProducers:
        return EndPoints.getResSectionForHome;
      case SectionType.neama:
        return EndPoints.getResSectionForNaema;
    }
  }
}
