import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/money_management/data/api/config_client.dart';
import 'package:foodzdashbord/features/money_management/data/models/config_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

enum ConfigStatus { initial, loading, loaded, error, saving, saved }

class ConfigState {
  final ConfigStatus status;
  final List<ConfigItem> configs;
  final String? errorMessage;
  final String? successMessage;

  // Individual config values for easy access
  final String baseKm;
  final String basePrice;
  final String afterBasePrice;
  final String dManPercentage;
  final String systemFees;
  final String bankNumber;
  
  // Kill switches
  final bool homeKillSwitch;
  final bool restaurantKillSwitch;
  final bool plessingKillSwitch;

  ConfigState({
    this.status = ConfigStatus.initial,
    this.configs = const [],
    this.errorMessage,
    this.successMessage,
    this.baseKm = '',
    this.basePrice = '',
    this.afterBasePrice = '',
    this.dManPercentage = '',
    this.systemFees = '',
    this.bankNumber = '',
    this.homeKillSwitch = false,
    this.restaurantKillSwitch = false,
    this.plessingKillSwitch = false,
  });

  ConfigState copyWith({
    ConfigStatus? status,
    List<ConfigItem>? configs,
    String? errorMessage,
    String? successMessage,
    String? baseKm,
    String? basePrice,
    String? afterBasePrice,
    String? dManPercentage,
    String? systemFees,
    String? bankNumber,
    bool? homeKillSwitch,
    bool? restaurantKillSwitch,
    bool? plessingKillSwitch,
  }) {
    return ConfigState(
      status: status ?? this.status,
      configs: configs ?? this.configs,
      errorMessage: errorMessage,
      successMessage: successMessage,
      baseKm: baseKm ?? this.baseKm,
      basePrice: basePrice ?? this.basePrice,
      afterBasePrice: afterBasePrice ?? this.afterBasePrice,
      dManPercentage: dManPercentage ?? this.dManPercentage,
      systemFees: systemFees ?? this.systemFees,
      bankNumber: bankNumber ?? this.bankNumber,
      homeKillSwitch: homeKillSwitch ?? this.homeKillSwitch,
      restaurantKillSwitch: restaurantKillSwitch ?? this.restaurantKillSwitch,
      plessingKillSwitch: plessingKillSwitch ?? this.plessingKillSwitch,
    );
  }
}

class ConfigCubit extends Cubit<ConfigState> {
  final IConfigClient _client;

  // Text controllers for the form fields
  final TextEditingController baseKmController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController afterBasePriceController = TextEditingController();
  final TextEditingController dManPercentageController = TextEditingController();
  final TextEditingController systemFeesController = TextEditingController();
  final TextEditingController bankNumberController = TextEditingController();

  ConfigCubit() 
      : _client = ConfigClientImpl(NetworkServices()),
        super(ConfigState());

  Future<void> fetchConfig() async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: ConfigStatus.loading));
    } catch (_) {}

    try {
      final result = await _client.getConfig();

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: ConfigStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? '', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (response) {
          // Parse config items
          String baseKm = '';
          String basePrice = '';
          String afterBasePrice = '';
          String dManPercentage = '';
          String systemFees = '';
          String bankNumber = '';
          bool homeKillSwitch = false;
          bool restaurantKillSwitch = false;
          bool plessingKillSwitch = false;

          for (var config in response.configs) {
            switch (config.name) {
              case 'baseKm':
                baseKm = config.value;
                baseKmController.text = config.value;
                break;
              case 'basePrice':
                basePrice = config.value;
                basePriceController.text = config.value;
                break;
              case 'afterBasePrice':
                afterBasePrice = config.value;
                afterBasePriceController.text = config.value;
                break;
              case 'dManPersentage':
                dManPercentage = config.value;
                dManPercentageController.text = config.value;
                break;
              case 'systemFees':
                systemFees = config.value;
                systemFeesController.text = config.value;
                break;
              case 'bankNumber':
              case 'BankNumber':
                bankNumber = config.value;
                bankNumberController.text = config.value;
                break;
              case 'homeKillSwitch':
                homeKillSwitch = config.value.toLowerCase() == 'true';
                break;
              case 'restaurantKillSwitch':
                restaurantKillSwitch = config.value.toLowerCase() == 'true';
                break;
              case 'plessingKillSwitch':
                plessingKillSwitch = config.value.toLowerCase() == 'true';
                break;
            }
          }

          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: ConfigStatus.loaded,
              configs: response.configs,
              baseKm: baseKm,
              basePrice: basePrice,
              afterBasePrice: afterBasePrice,
              dManPercentage: dManPercentage,
              systemFees: systemFees,
              bankNumber: bankNumber,
              homeKillSwitch: homeKillSwitch,
              restaurantKillSwitch: restaurantKillSwitch,
              plessingKillSwitch: plessingKillSwitch,
            ));
          } catch (_) {}
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      try {
        if (isClosed) return;
        emit(state.copyWith(
          status: ConfigStatus.error,
          errorMessage: 'Failed to load config: $e',
        ));
      } catch (_) {}
    }
  }

  Future<void> saveConfig() async {
    // Build config list from controllers
    final configs = [
      ConfigItem(name: 'baseKm', value: baseKmController.text),
      ConfigItem(name: 'basePrice', value: basePriceController.text),
      ConfigItem(name: 'afterBasePrice', value: afterBasePriceController.text),
      ConfigItem(name: 'dManPersentage', value: dManPercentageController.text),
      ConfigItem(name: 'systemFees', value: systemFeesController.text),
      ConfigItem(name: 'bankNumber', value: bankNumberController.text),
    ];

    try {
      if (isClosed) return;
      emit(state.copyWith(status: ConfigStatus.saving));
    } catch (_) {}

    final result = await _client.setConfig(configs);

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            status: ConfigStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? '', const Locale('ar')),
          ));
        } catch (_) {}
      },
      (message) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            status: ConfigStatus.saved,
            successMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
            configs: configs,
          ));
        } catch (_) {}
      },
    );
  }

  Future<void> toggleKillSwitch(String switchName, bool newValue) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: ConfigStatus.saving));
    } catch (_) {}

    final result = await _client.updateConfig(switchName, newValue.toString());

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            status: ConfigStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? '', const Locale('ar')),
          ));
        } catch (_) {}
      },
      (message) {
        // Update the specific kill switch in state
        try {
          if (isClosed) return;
          
          ConfigState updatedState;
          switch (switchName) {
            case 'homeKillSwitch':
              updatedState = state.copyWith(
                status: ConfigStatus.saved,
                successMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
                homeKillSwitch: newValue,
              );
              break;
            case 'restaurantKillSwitch':
              updatedState = state.copyWith(
                status: ConfigStatus.saved,
                successMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
                restaurantKillSwitch: newValue,
              );
              break;
            case 'plessingKillSwitch':
              updatedState = state.copyWith(
                status: ConfigStatus.saved,
                successMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
                plessingKillSwitch: newValue,
              );
              break;
            default:
              updatedState = state.copyWith(
                status: ConfigStatus.saved,
                successMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
              );
          }
          
          emit(updatedState);
        } catch (_) {}
      },
    );
  }

  @override
  Future<void> close() {
    baseKmController.dispose();
    basePriceController.dispose();
    afterBasePriceController.dispose();
    dManPercentageController.dispose();
    systemFeesController.dispose();
    bankNumberController.dispose();
    return super.close();
  }
}
