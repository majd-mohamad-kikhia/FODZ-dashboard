import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/orders/data/models/order_model.dart';
import 'package:foodzdashbord/features/orders/data/models/orders_response_model.dart';

abstract class IOrdersClient {
  Future<Either<AppException, List<OrderModel>>> fetchOrders();
  Future<Either<AppException, void>> cancelOrder(int orderId, String reason);
}

class OrdersClientImpl implements IOrdersClient {
  final IRemoteDataSource _net;

  OrdersClientImpl(this._net);


  @override
  Future<Either<AppException, List<OrderModel>>> fetchOrders() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.getProducts,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final OrdersResponseModel response = 
              OrdersResponseModel.fromJson(data as Map<String, dynamic>);
          return Right(response.orders);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch orders: ${e.toString()}');
    }
  }
    
  @override
  Future<Either<AppException, void>> cancelOrder(int orderId, String reason) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.cancelOrder,
          body: {
            'orderId': orderId,
            'cancellationReason': reason,
          },
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          return Right(null);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to cancel order: ${e.toString()}');
    }
  }
}
