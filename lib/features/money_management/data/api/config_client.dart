import 'package:dartz/dartz.dart';
import 'package:foodzdashbord/core/api/end_points.dart';
import 'package:foodzdashbord/core/api/network_interface.dart';
import 'package:foodzdashbord/core/error/exceptions.dart';
import 'package:foodzdashbord/features/money_management/data/models/config_model.dart';

abstract class IConfigClient {
  Future<Either<AppException, ConfigResponse>> getConfig();
  Future<Either<AppException, String>> setConfig(List<ConfigItem> configs);
  Future<Either<AppException, String>> updateConfig(String configName, String value);
}

class ConfigClientImpl implements IConfigClient {
  final IRemoteDataSource _net;

  ConfigClientImpl(this._net);

  @override
  Future<Either<AppException, ConfigResponse>> getConfig() async {
    try {
      final Either<AppException, dynamic> res = await _net.coustomGet(
        RemoteDataBundle(
          networkPath: EndPoints.getConfig,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final ConfigResponse response =
              ConfigResponse.fromJson(data as Map<String, dynamic>);
          return Right(response);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to fetch config: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> setConfig(List<ConfigItem> configs) async {
    try {
      final body = {
        'config': configs.map((c) => c.toJson()).toList(),
      };

      final Either<AppException, dynamic> res = await _net.customPut(
        RemoteDataBundle(
          networkPath: EndPoints.setConfig,
          body: body,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final message = data['message'] as String? ?? 'Config updated successfully';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to update config: ${e.toString()}');
    }
  }

  @override
  Future<Either<AppException, String>> updateConfig(String configName, String value) async {
    try {
      final body = {
        'value': value,
      };

      final Either<AppException, dynamic> res = await _net.customPut(
        RemoteDataBundle(
          networkPath: '${EndPoints.updateConfige}$configName',
          body: body,
        ),
      );

      return res.fold(
        (error) {
          return Left(error);
        },
        (data) {
          final message = data['message'] as String? ?? 'Config updated successfully';
          return Right(message);
        },
      );
    } catch (e) {
      throw ServerException(msg: 'Failed to update config: ${e.toString()}');
    }
  }
}
