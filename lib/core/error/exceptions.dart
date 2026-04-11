import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/status_code.dart';

String _extractErrorMessage(dynamic data) {
  if (data == null) return 'Unknown error';
  if (data is String) {
    try {
      final decoded = json.decode(data);
      if (decoded is Map && decoded.containsKey('message')) {
        return decoded['message'];
      }
      return data;
    } catch (e) {
      return data;
    }
  }
  if (data is Map && data.containsKey('message')) {
    return data['message'];
  }
  return 'حدث خطأ في المخدم';
}

dynamic exceptionHandling(Response response) {
  final errorMessage = _extractErrorMessage(response.data);
  switch (response.statusCode) {
    case StatusCode.unauthorized:
      return UnAuthorizedException(msg: errorMessage);
    case StatusCode.forbidden:
      return ForbiddenException(msg: errorMessage);
    case StatusCode.notFound:
      return NotFoundException(msg: errorMessage);
    case StatusCode.conflict:
      return UserAlreadyExistsException(msg: errorMessage);
    case StatusCode.methodNotAllowed:
      return MethodNotAllowedException(msg: errorMessage);
    case StatusCode.otpException:
      return OTPException(msg: errorMessage);
    case StatusCode.toManyRequest:
      return ToManyRequestException(msg: errorMessage);
    case StatusCode.internalServerError:
      return InternalServerError(msg: errorMessage);
    case StatusCode.userAccessDenied:
      return UserAccessDeniedException(msg: errorMessage);
    default:
      return ServerException(msg: errorMessage);
  }
}

class AppException implements Exception {
  String? message;
  AppException([this.message]);
  // String? get message => _message;
  List<Object?> get props => [message];
}

class ServerException extends AppException {
  ServerException({this.statusCode, required String msg}) : super(msg);
  int? statusCode;
}

class CacheException extends AppException {
  CacheException({required String msg}) : super(msg);
}

class BadRequestException extends AppException {
  BadRequestException({required String msg}) : super(msg);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException({required String msg}) : super(msg);
}

class NotFoundException extends AppException {
  NotFoundException({required String msg}) : super(msg);
}

class FetchDataException extends AppException {
  FetchDataException({required String msg}) : super(msg);
}

class ToManyRequestException extends AppException {
  ToManyRequestException({required String msg}) : super(msg);
}

class OTPException extends AppException {
  OTPException({required String msg}) : super(msg);
}

class UserAlreadyExistsException extends AppException {
  UserAlreadyExistsException({required String msg}) : super(msg);
}

class ForbiddenException extends AppException {
  ForbiddenException({required String msg}) : super(msg);
}

class MethodNotAllowedException extends AppException {
  MethodNotAllowedException({required String msg}) : super(msg);
}

class InternalServerError extends AppException {
  InternalServerError({required String msg}) : super(msg);
}

class UserAccessDeniedException extends AppException {
  UserAccessDeniedException({required String msg}) : super(msg);
}
