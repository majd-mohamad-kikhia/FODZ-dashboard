import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/auth/data/models/login_request_model.dart';
import 'package:foodzdashbord/features/auth/data/models/login_response_model.dart';

abstract class IAuthClient {
  Future<Either<AppException, LoginResponseModel>> login(LoginRequestModel request);
}

class AuthClientImpl implements IAuthClient {
  final IRemoteDataSource _net;

  AuthClientImpl(this._net);

  @override
  Future<Either<AppException, LoginResponseModel>> login(LoginRequestModel request) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.login,
          body: request.toJson(),
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final LoginResponseModel response = LoginResponseModel.fromJson(data as Map<String, dynamic>);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to login: ${e.toString()}');
    }
  }
}
