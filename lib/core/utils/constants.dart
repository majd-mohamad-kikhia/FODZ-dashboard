// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';

enum SnackBarVideoStates { SUCCESS, ERROR, WARNING }

enum OnItemClick { PRIVACYANDPOLICY, TERMSANDCONDITIONS, DELETEACCOUNT, LOGOUT }

enum FontSize { SMALL, MEDIUM, LARGE }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

extension ResponsiveNum on num {
  double get rh => ((toDouble() / 1080) * 100).h;
  double get rw => ((toDouble() / 1920) * 100).w;
  double get rf {
    final value = Adaptive.sp(toDouble());
    final minimum = Adaptive.sp(10);
    return value < minimum ? minimum : value;
  }
}

extension EmptyPadding on num {
  Widget get vSpace => SizedBox(height: rh);
  Widget get hSpace => SizedBox(width: rw);
}

EdgeInsets responsiveInsetsAll(double value) {
  final inset = value.rw;
  return EdgeInsets.all(inset);
}

EdgeInsets responsiveInsetsSymmetric({double horizontal = 0, double vertical = 0}) {
  return EdgeInsets.symmetric(horizontal: horizontal.rw, vertical: vertical.rh);
}

EdgeInsets responsiveInsetsOnly({
  double left = 0,
  double top = 0,
  double right = 0,
  double bottom = 0,
}) {
  return EdgeInsets.only(
    left: left.rw,
    top: top.rh,
    right: right.rw,
    bottom: bottom.rh,
  );
}

/// Show a success snackbar with green background
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontSize: 12.rf,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

/// Show an error snackbar with red background
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontSize: 14.rf,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

class Global {
  static final GlobalKey writingBoxKey = GlobalKey();

  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");

  static final GlobalKey bottomNavKey = GlobalKey();

  static final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> otherKey = GlobalKey<ScaffoldState>();

  static final GlobalKey homeHeaderKey = GlobalKey();

  static final GlobalKey vipKey = GlobalKey();

  static final Global _instanceKey = Global._internalKey();

  factory Global() => _instanceKey;

  Global._internalKey();

  /// text scale of device
  double _textScale = 1;

  get textScaleOfDevice => _textScale;

  set textScaleOfDevice(value) => _textScale = value;

  Size _size = const Size(350, 500);

  Size get size => _size;

  set size(value) => _size = value;

  /// to show if the app in the arabic languange or english
  bool _isArabic = false;

  bool get isArabic => _isArabic;

  set isArabic(value) => _isArabic = value;

  bool _isChinese = false;

  bool get isChinese => _isChinese;

  set isChinese(value) => _isChinese = value;

  String _locale = 'en';

  String get locale => _locale;

  set locale(value) => _locale = value;
}

class Corners {
  static const double btn = s5;
  static const double sm = 10;
  static const double xsm = 5;
  static const double dialog = 12;

  /// [Ying_app]
  static const double corner4 = 14;
  static const Radius radius4 = Radius.circular(corner14);
  static const BorderRadius border4 = BorderRadius.all(radius14);

  static const double corner14 = 14;
  static const Radius radius14 = Radius.circular(corner14);
  static const BorderRadius border14 = BorderRadius.all(radius14);

  static const double corner16 = 16;
  static const Radius radius16 = Radius.circular(corner16);
  static const BorderRadius border16 = BorderRadius.all(radius16);

  static const double corner15 = 15;
  static const Radius radius15 = Radius.circular(corner15);
  static const BorderRadius border15 = BorderRadius.all(radius15);

  static const double corner18 = 18;
  static const Radius radius18 = Radius.circular(corner18);
  static const BorderRadius border18 = BorderRadius.all(radius18);
  static const double corner20 = 20;
  static const Radius radius20 = Radius.circular(corner20);
  static const BorderRadius border20 = BorderRadius.all(radius20);

  /// Xs
  static const double s3 = 3;

  static BorderRadius get s3Border => BorderRadius.all(s3Radius);

  static Radius get s3Radius => const Radius.circular(s3);

  /// Small
  static const double s5 = 5;

  static BorderRadius get s5Border => BorderRadius.all(s5Radius);

  static Radius get s5Radius => const Radius.circular(s5);

  /// Medium
  static const double s8 = 8;

  static const BorderRadius s8Border = BorderRadius.all(s8Radius);

  static const Radius s8Radius = Radius.circular(s8);

  /// Large
  static const double s10 = 10;

  static BorderRadius get s10Border => BorderRadius.all(s10Radius);

  static Radius get s10Radius => const Radius.circular(s10);
  static const BorderRadius smBorder = BorderRadius.all(smRadius);
  static const Radius smRadius = Radius.circular(sm);
  static const double med = 15;
  static const BorderRadius medBorder = BorderRadius.all(medRadius);
  static const Radius medRadius = Radius.circular(med);

  static const double lg = 20;
  static const double xlg = 25;
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static const Radius lgRadius = Radius.circular(lg);
  static const double xl = 30;
  static const double xll = 40;
  static const double xxl = 60;
}

class CustomBoxDecoration {
  static BoxDecoration decoration18 = BoxDecoration(
    borderRadius: Corners.border18,
    //color: AppColors.grey800,
  );

  //upload icon + card library dicoration
  static BoxDecoration decoration20 = BoxDecoration(
    borderRadius: Corners.border20,
    //color: AppColors.grey800,
  );
  static BoxDecoration dismissibleDecoration = BoxDecoration(
    borderRadius: Corners.border20,
    //color: AppColors.redColor,
  );
  static BoxDecoration decoration16 = BoxDecoration(
    borderRadius: Corners.border16,
    //color: AppColors.grey800,
  );
  static BoxDecoration vipDecoration = BoxDecoration(
    borderRadius: Corners.border20,
    // gradient: ConstLinearGradiant.linearGradientlogoutBackground,
    //border: Border.all(color: AppColors.lightOrange),
    //color: AppColors.darkRed.withOpacity(.1),
  );
  static BoxDecoration tabDecoration = BoxDecoration(
    borderRadius: Corners.border16,
    //color: AppColors.redColor,
  );

  ///
}

class ConstLinearGradiant {
  static const LinearGradient linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(231, 199, 180, 1),
      Color.fromRGBO(224, 151, 135, 1),
      Color.fromRGBO(214, 77, 65, .9),
      Color.fromRGBO(212, 85, 66, 1),
      Color.fromRGBO(208, 118, 72, 1),
      Color.fromRGBO(207, 131, 75, 1),
    ],
  );
  static const LinearGradient linearGradientlogoutBackground = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(231, 199, 180, .9),
      Color.fromRGBO(224, 151, 135, .9),
      Color.fromRGBO(214, 77, 65, .9),
      Color.fromRGBO(212, 85, 66, .9),
      Color.fromRGBO(208, 118, 72, .9),
      Color.fromRGBO(207, 131, 75, .9),
    ],
  );
  static const LinearGradient linearGradientDictionaryBackground =
      LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromRGBO(231, 199, 180, .85),
          Color.fromRGBO(224, 151, 135, 0.85),
          Color.fromRGBO(214, 77, 65, .85),
          Color.fromRGBO(212, 85, 66, 0.85),
          Color.fromRGBO(208, 118, 72, 0.85),
          Color.fromRGBO(207, 131, 75, 0.85),
        ],
      );
  static LinearGradient linearGradientLoginBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryRed,
      AppColors.primaryRed.withValues(alpha: 0.5),
      Colors.transparent,
    ],
  );

  static const LinearGradient linearGradientComingSoon = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(255, 255, 255, .35),
      Color.fromRGBO(255, 255, 255, .34),
      Color.fromRGBO(255, 255, 255, .29),
      Color.fromRGBO(255, 255, 255, .22),
      Color.fromRGBO(255, 255, 255, .12),
      Color.fromRGBO(255, 255, 255, .0),
    ],
  );
}
