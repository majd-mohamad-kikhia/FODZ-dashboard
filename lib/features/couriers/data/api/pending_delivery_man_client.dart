import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/couriers/data/models/pending_delivery_man_model.dart';

abstract class IPendingDeliveryManClient {
  Future<Either<AppException, PendingDeliveryMenResponse>> getPendingDeliveryMen();
  Future<Either<AppException, String>> approveDeliveryMan(int deliveryManId);
}

class PendingDeliveryManClientImpl implements IPendingDeliveryManClient {
  final IRemoteDataSource _net;

  PendingDeliveryManClientImpl(this._net);

  @override
  Future<Either<AppException, PendingDeliveryMenResponse>> getPendingDeliveryMen() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.getPendingDman,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final PendingDeliveryMenResponse response =
              PendingDeliveryMenResponse.fromJson(data as Map<String, dynamic>);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch pending delivery men: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> approveDeliveryMan(int deliveryManId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: '${EndPoints.accepteDMan}$deliveryManId',
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final message = data['message'] as String? ?? 'Delivery man approved successfully';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to approve delivery man: ${e.toString()}');
    }
  }
}
