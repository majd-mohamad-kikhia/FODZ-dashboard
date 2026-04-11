import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/couriers/data/models/delivery_man_model.dart';

abstract class IDeliveryManClient {
  Future<Either<AppException, DeliveryManResponse>> getDeliveryMen({
    required int page,
    required int limit,
  });
  Future<Either<AppException, String>> banDeliveryMan(int deliveryManId);
  Future<Either<AppException, String>> unbanDeliveryMan(int deliveryManId);
  Future<Either<AppException, String>> giveWarning(int deliveryManId, String title, String body);
}

class DeliveryManClientImpl implements IDeliveryManClient {
  final IRemoteDataSource _net;

  DeliveryManClientImpl(this._net);

  @override
  Future<Either<AppException, DeliveryManResponse>> getDeliveryMen({
    required int page,
    required int limit,
  }) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.listDman,
          urlParams: {
            'page': page,
            'limit': limit,
          },
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final DeliveryManResponse response =
              DeliveryManResponse.fromJson(data as Map<String, dynamic>);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch delivery men: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> banDeliveryMan(int deliveryManId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: 'admin/delivery-man/$deliveryManId/ban',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final message = data['message'] as String? ?? 'Delivery man banned successfully';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to ban delivery man: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> unbanDeliveryMan(int deliveryManId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: 'admin/delivery-man/$deliveryManId/unban',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final message = data['message'] as String? ?? 'Delivery man unbanned successfully';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to unban delivery man: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> giveWarning(int deliveryManId, String title, String body) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.giveWarning,
          body: {
            'deliveryManId': deliveryManId,
            'title': title,
            'body': body,
          },
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final message = data['message'] as String? ?? 'Warning sent successfully';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to give warning: ${e.toString()}');
    }
  }
}
