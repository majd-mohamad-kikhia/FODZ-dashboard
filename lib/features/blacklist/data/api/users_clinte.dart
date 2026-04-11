import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/features/blacklist/data/models/ban_user_request.dart';
import 'package:foodzdashbord/features/blacklist/data/models/banned_user_model.dart';
import 'package:foodzdashbord/features/blacklist/data/models/get_all_users_model.dart';

class GetBlockedUsersClient {
  final NetworkServices _net = NetworkServices();

  Future<Either<AppException, List<BannedUserModel>>> fetchBlockedUsers() async {
    try {
      final Either<AppException, dynamic> res =
          await _net.coustomGet(RemoteDataBundle(networkPath: EndPoints.getBlockedUsers));

      return res.fold(
        (error) => Left(error),
        (data) {
          final List<dynamic> usersJson = data['bannedUsers'] as List<dynamic>;
          final users = usersJson.map((json) => BannedUserModel.fromJson(json)).toList();
          return Right(users);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch blocked users');
    }
  }
}
class GetAllUsersClient {
  final NetworkServices _net = NetworkServices();

  Future<Either<AppException, List<UserModel>>> fetchAllUsers() async {
    try {
      final Either<AppException, dynamic> res =
          await _net.coustomGet(RemoteDataBundle(networkPath: EndPoints.getAllUsers));

      return res.fold(
        (error) => Left(error),
        (data) {
          final List<dynamic> usersJson = data['users'] as List<dynamic>;
          final users = usersJson.map((json) => UserModel.fromJson(json)).toList();
          return Right(users);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch users');
    }
  }
}
class BanUserClient {
  final NetworkServices _net = NetworkServices();

  Future<Either<AppException, dynamic>> banUser(int userId, String reason) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.bannedUser + userId.toString(),
          body: BanUserRequest(banReason: reason).toJson(),
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) => Right(data),
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to ban user');
    }
  }
}
class UnbanUserClient {
  final NetworkServices _net = NetworkServices();

  Future<Either<AppException, dynamic>> unbanUser(int userId) async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomPost(
        RemoteDataBundle(
          networkPath: EndPoints.unbanUser + userId.toString(),
        ),
      );

      return res.fold(
        (error) => Left(error),
        (data) => Right(data),
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to unban user');
    }
  }
}