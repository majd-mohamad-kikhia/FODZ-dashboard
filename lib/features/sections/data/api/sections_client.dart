import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/sections/data/models/section_response.dart';

class SectionsClient {
  final NetworkServices _net;

  SectionsClient(this._net);

  Future<Either<AppException, SectionsResponse>> getAllSections() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.getAllSections,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final response = SectionsResponse.fromJson(data);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch sections');
    }
  }

  Future<Either<AppException, Section>> createSection({
    required String screen,
    required String type,
    required String name,
    required List<int> ids,
  }) async {
    try {
      final body = {
        'screen': screen,
        'type': type,
        'name': name,
        'ids': ids,
      };

      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.createSection,
          body: body,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final section = Section.fromJson(data);
          return Right(section);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to create section');
    }
  }

  Future<Either<AppException, Section>> updateSection({
    required int sectionId,
    required String screen,
    required String type,
    required String name,
    required List<int> ids,
  }) async {
    try {
      final body = {
        'screen': screen,
        'type': type,
        'name': name,
        'ids': ids,
      };

      final Either<AppException, dynamic> res = await _net.customPut(
        RemoteDataBundle(
          networkPath: '${EndPoints.createSection}/$sectionId',
          body: body,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final section = Section.fromJson(data);
          return Right(section);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to update section');
    }
  }

  Future<Either<AppException, dynamic>> deleteSection({
    required int sectionId,
  }) async {
    try {
      final Either<AppException, dynamic> res = await _net.customDelete(
        RemoteDataBundle(
          networkPath: '${EndPoints.deleteSectino}$sectionId',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          return Right(data);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to delete section');
    }
  }
}
