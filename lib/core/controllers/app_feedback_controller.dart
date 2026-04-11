import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';

enum AppFeedbackType { info, success, error }

class AppFeedbackMessage {
  AppFeedbackMessage({
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
  });

  final String title;
  final String message;
  final AppFeedbackType type;
  final Duration duration;

  Color get backgroundColor {
    switch (type) {
      case AppFeedbackType.success:
        return AppColors.primaryRed;
      case AppFeedbackType.error:
        return Colors.redAccent;
      case AppFeedbackType.info:
        return const Color(0xFF1E88E5);
    }
  }
}

