// ignore_for_file: type_literal_in_constant_pattern, must_be_immutable

import 'package:equatable/equatable.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return failure.msg;
    case UserFoundFailure:
      return failure.msg;
    case CacheFailure:
      return failure.msg;
    case FetchDataFailure:
      return failure.msg;
    case UnAuthorizedFailure:
      return failure.msg;
    case BadRequestFailure:
      return failure.msg;
    case ToManyRequestFailure:
      return failure.msg;
    case OTPFailure:
      return failure.msg;
    case UserAlreadyExistsFailure:
      return failure.msg;
    case ForbiddenFailure:
      return failure.msg;

    default:
      return failure.msg;
  }
}

abstract class Failure extends Equatable {
  String msg;
  Failure({required this.msg});
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  String message;
  ServerFailure({required this.message}) : super(msg: message);
}

class BadRequestFailure extends Failure {
  String message;
  BadRequestFailure({required this.message}) : super(msg: message);
}

class CacheFailure extends Failure {
  String message;
  CacheFailure({required this.message}) : super(msg: message);
}

class UserFoundFailure extends Failure {
  String message;
  UserFoundFailure({required this.message}) : super(msg: message);
}

class FetchDataFailure extends Failure {
  String message;
  FetchDataFailure({required this.message}) : super(msg: message);
}

class UnAuthorizedFailure extends Failure {
  String message;
  UnAuthorizedFailure({required this.message}) : super(msg: message);
}

class ToManyRequestFailure extends Failure {
  String message;
  ToManyRequestFailure({required this.message}) : super(msg: message);
}

class OTPFailure extends Failure {
  String message;
  OTPFailure({required this.message}) : super(msg: message);
}

class UserAlreadyExistsFailure extends Failure {
  String message;
  UserAlreadyExistsFailure({required this.message}) : super(msg: message);
}

class ForbiddenFailure extends Failure {
  String message;
  ForbiddenFailure({required this.message}) : super(msg: message);
}
