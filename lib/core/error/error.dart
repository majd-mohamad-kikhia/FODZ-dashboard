// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:real_estate/core/error/exceptions.dart';

// /// the class returned when ever an
// /// api call had an error
// /// it maps the app exception and make returns the error
// class ErrorModel {
//   int? statusCode;
//   String? error;
//   int? userId;
//   dynamic data;
//   String? phone;
//   String? email;
//   String? password;
//   String? signInMessage;
//   String? payemntError;
//   ErrorModel(this.error, this.data, this.phone, this.email, this.signInMessage,
//       this.password, this.statusCode, this.payemntError);

//   ErrorModel.expection(AppException e) {
//     error = e.message;
//   }
//   ErrorModel.expectionString(String e) {
//     error = e;
//   }
//   ErrorModel.signUpExpection(AppException e) {
//     // if (error!.contains("Your phone number has not been verified yet")) {
//     //   String s = e.data['message'];
//     //   String id = s.split('_').last.trim();
//     //   userId = int.parse(id);
//     // }
//   }
//   // ignore: empty_constructor_bodies
//   ErrorModel.fromException(AppException e) {
//     error = e.message;
//   }
// }

// dynamic exceptionHandling(Response response) {
//   switch (response.statusCode) {
//     case 400:
//       return BadRequestException(msg: json.decode(response.data)['message']);
//     case 401:
//       return UnAuthorizedException(msg: json.decode(response.data)['message']);
//     case 403:
//       return ForbiddenException(msg: json.decode(response.data)['message']);
//     case 409:
//       return UserAlreadyExistsException(
//           msg: json.decode(response.data)['message']);
//     case 423:
//       return OTPException(msg: json.decode(response.data)['message']);
//     case 429:
//       return ToManyRequestException(msg: json.decode(response.data)['message']);
//     case 500:
//       return ServerException(msg: json.decode(response.data)['message']);
//     case 404:
//       return NotFoundException(msg: json.decode(response.data)['message']);
//     default:
//       return ServerException(msg: json.decode(response.data)['message']);
//   }
// }

// class ServerException implements Exception {
//   ServerException({this.statusCode, required this.msg});
//   int? statusCode;
//   String msg;
// }

// class CacheException implements Exception {
//   CacheException({required this.msg});
//   String msg;
// }

// class BadRequestException implements Exception {
//   BadRequestException({required this.msg});
//   String msg;
// }

// class UnAuthorizedException implements Exception {
//   UnAuthorizedException({required this.msg});
//   String msg;
// }

// class NotFoundException implements Exception {
//   NotFoundException({required this.msg});
//   String msg;
// }

// class FetchDataException implements Exception {
//   FetchDataException({required this.msg});
//   String msg;
// }

// class ToManyRequestException implements Exception {
//   ToManyRequestException({required this.msg});
//   String msg;
// }

// class OTPException implements Exception {
//   OTPException({required this.msg});
//   String msg;
// }

// class UserAlreadyExistsException implements Exception {
//   UserAlreadyExistsException({required this.msg});
//   String msg;
// }

// class ForbiddenException implements Exception {
//   ForbiddenException({required this.msg});
//   String msg;
// }
