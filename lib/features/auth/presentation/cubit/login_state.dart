part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, error }

enum LoginFieldStatus { initial, valid, invalid }

class LoginState {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage = '',
    this.phoneStatus = LoginFieldStatus.initial,
    this.passwordStatus = LoginFieldStatus.initial,
    this.phoneError = '',
    this.passwordError = '',
    this.isPasswordObscured = true,
  });

  final LoginStatus status;
  final String errorMessage;
  final LoginFieldStatus phoneStatus;
  final LoginFieldStatus passwordStatus;
  final String phoneError;
  final String passwordError;
  final bool isPasswordObscured;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    LoginFieldStatus? phoneStatus,
    LoginFieldStatus? passwordStatus,
    String? phoneError,
    String? passwordError,
    bool? isPasswordObscured,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      phoneStatus: phoneStatus ?? this.phoneStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      phoneError: phoneError ?? this.phoneError,
      passwordError: passwordError ?? this.passwordError,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
    );
  }
}
