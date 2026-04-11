import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/auth/data/api/auth_client.dart';
import 'package:foodzdashbord/features/auth/data/models/login_request_model.dart';
import 'package:foodzdashbord/features/auth/data/services/auth_service.dart';
import 'package:foodzdashbord/core/utils/validators.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final IAuthClient _authClient = AuthClientImpl(NetworkServices());

  Future<void> login() async {
    final isPhoneValid = _validatePhone();
    final isPasswordValid = _validatePassword();

    if (!isPhoneValid || !isPasswordValid) {
      _emitSafely(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'الرجاء تصحيح الحقول المحددة باللون الأحمر',
        ),
      );
      return;
    }

    _emitSafely(
      state.copyWith(
        status: LoginStatus.loading,
        errorMessage: '',
      ),
    );

    final request = LoginRequestModel(
      phoneNumber: phoneController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      final result = await _authClient.login(request);

      result.fold(
        (error) {
          _emitSafely(
            state.copyWith(
              status: LoginStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل تسجيل الدخول', const Locale('ar')),
            ),
          );
        },
        (response) async {
          await _authService.saveAuthData(
            token: response.token,
            admin: response.admin,
          );
          _emitSafely(state.copyWith(status: LoginStatus.success));
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      _emitSafely(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'Login failed: $e',
        ),
      );
    }
  }

  void onPhoneChanged(String value) {
    if (value.trim().isEmpty) {
      _emitSafely(
        state.copyWith(
          phoneStatus: LoginFieldStatus.initial,
          phoneError: '',
          status: LoginStatus.initial,
        ),
      );
      return;
    }
    _validatePhone(value);
  }

  void onPasswordChanged(String value) {
    if (value.trim().isEmpty) {
      _emitSafely(
        state.copyWith(
          passwordStatus: LoginFieldStatus.initial,
          passwordError: '',
          status: LoginStatus.initial,
        ),
      );
      return;
    }
    _validatePassword(value);
  }

  void togglePasswordVisibility() {
    _emitSafely(
      state.copyWith(isPasswordObscured: !state.isPasswordObscured),
    );
  }

  bool _validatePhone([String? value]) {
    final input = (value ?? phoneController.text).trim();
    final error = AppValidators.validatePhone(input);
    final status = error == null ? LoginFieldStatus.valid : LoginFieldStatus.invalid;
    _emitSafely(
      state.copyWith(
        phoneStatus: status,
        phoneError: error ?? '',
      ),
    );
    return status == LoginFieldStatus.valid;
  }

  bool _validatePassword([String? value]) {
    final input = (value ?? passwordController.text);
    final error = AppValidators.validatePassword(input);
    final status = error == null ? LoginFieldStatus.valid : LoginFieldStatus.invalid;
    _emitSafely(
      state.copyWith(
        passwordStatus: status,
        passwordError: error ?? '',
      ),
    );
    return status == LoginFieldStatus.valid;
  }

  void _emitSafely(LoginState newState) {
    try {
      if (isClosed) {
        return;
      }
      emit(newState);
    } catch (_) {}
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
