import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/auth/presentation/cubit/login_cubit.dart';
import 'package:foodzdashbord/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginCubit(), child: const _LoginView());
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (state.status == LoginStatus.error) {
              showErrorSnackBar(context, state.errorMessage);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 450),
                margin: EdgeInsets.all(24),
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 64,
                      color: AppColors.primaryRed,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'لوحة تحكم المسؤول',
                      style: TextStyle(fontSize: 16, color: AppColors.grey600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    const _PhoneField(),
                    SizedBox(height: 20),
                    const _PasswordField(),
                    SizedBox(height: 32),
                    const _LoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField();

  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.phoneStatus != current.phoneStatus ||
          previous.phoneError != current.phoneError,
      builder: (context, state) {
        final bool isValid = state.phoneStatus == LoginFieldStatus.valid;
        final bool isInvalid = state.phoneStatus == LoginFieldStatus.invalid;
        final Color borderColor = isValid
            ? AppColors.successGreen
            : isInvalid
            ? AppColors.primaryRed
            : AppColors.grey200;
        final double borderWidth = (isValid || isInvalid) ? 2 : 1.5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رقم الهاتف',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: cubit.phoneController,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              onChanged: cubit.onPhoneChanged,
              style: TextStyle(fontSize: 15, color: AppColors.textDark),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: '0999999999',
                hintStyle: TextStyle(fontSize: 15, color: AppColors.grey400),
                prefixIcon: Icon(
                  Icons.phone_rounded,
                  color: AppColors.grey500,
                  size: 20,
                ),
                border: _buildBorder(borderColor, borderWidth),
                enabledBorder: _buildBorder(borderColor, borderWidth),
                focusedBorder: _buildBorder(borderColor, borderWidth),
                errorText: state.phoneError.isEmpty ? null : state.phoneError,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryRed,
                  height: 1.2,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.passwordStatus != current.passwordStatus ||
          previous.passwordError != current.passwordError ||
          previous.isPasswordObscured != current.isPasswordObscured,
      builder: (context, state) {
        final bool isValid = state.passwordStatus == LoginFieldStatus.valid;
        final bool isInvalid = state.passwordStatus == LoginFieldStatus.invalid;
        final Color borderColor = isValid
            ? AppColors.successGreen
            : isInvalid
            ? AppColors.primaryRed
            : AppColors.grey200;
        final double borderWidth = (isValid || isInvalid) ? 2 : 1.5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'كلمة المرور',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: cubit.passwordController,
              obscureText: state.isPasswordObscured,
              onChanged: cubit.onPasswordChanged,
              style: TextStyle(fontSize: 15, color: AppColors.textDark),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: '••••••••',
                hintStyle: TextStyle(fontSize: 15, color: AppColors.grey400),
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: AppColors.grey500,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.isPasswordObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.grey500,
                    size: 20,
                  ),
                  onPressed: cubit.togglePasswordVisibility,
                ),
                border: _buildBorder(borderColor, borderWidth),
                enabledBorder: _buildBorder(borderColor, borderWidth),
                focusedBorder: _buildBorder(borderColor, borderWidth),
                errorText: state.passwordError.isEmpty
                    ? null
                    : state.passwordError,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryRed,
                  height: 1.2,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;

        return ElevatedButton(
          onPressed: isLoading ? null : cubit.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            disabledBackgroundColor: AppColors.grey300,
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        );
      },
    );
  }
}
