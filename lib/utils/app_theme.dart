import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AppTheme {
  const AppTheme._();

  /// Figma resources start here
  static const fontPoppins = 'Poppins';
  static const fontMavenPro = 'MavenPro';

  static const Duration overlayAnimDuration = Duration(milliseconds: 500);
  static const int _primaryColor = 0xFFFF6300;
  static const MaterialColor primarySwatch =
  MaterialColor(_primaryColor, <int, Color>{
    50: Color(0xFFFFEFE5),
    100: Color(0xFFFFEFE5),
    200: Color(0xFFFFDFCC),
    300: Color(0xFFFFC19A),
    400: Color(0xFFFFC19A),
    500: Color(0xFFFFA265),
    600: Color(0xFFFFA265),
    700: Color(0xFFFF8331),
    800: Color(0xFFFF8331),
    900: Color(_primaryColor),
  });

  static const int _secondaryColor = 0xFF5C0FD9;
  static const MaterialColor secondarySwatch =
  MaterialColor(_secondaryColor, <int, Color>{
    50: Color(0xFFEEE7FA),
    100: Color(0xFFEEE7FA),
    200: Color(0xFFDECFF6),
    300: Color(0xFFBFA0F0),
    400: Color(0xFFBFA0F0),
    500: Color(0XFF9D6FE9),
    600: Color(0XFF9D6FE9),
    700: Color(0xFF7D3EE4),
    800: Color(0xFF7D3EE4),
    900: Color(_secondaryColor),
  });
  static const Color neutralTertiarySuperLightColor = Color(0xFFF0F3F5);
  static const Color neutralTertiaryLightColor = Color(0xFFB6C4C8);
  static const Color neutralTertiaryDarkColor = Color(0xFF485B60);

  static const int _charcoalColorCode = 0xFF333333;
  static const Color charcoalColor = Color(_charcoalColorCode);
  static const int _darkGreyColorCode = 0xFF666666;
  static const Color darkGreyColor = Color(_darkGreyColorCode);
  static const int _separatorGreyColorCode = 0xFFE1E1DF;
  static const Color separatorGreyColor = Color(_separatorGreyColorCode);
  static const int _lightGreyColorCode = 0xFFF5F5F5;
  static const Color lightGreyColor = Color(_lightGreyColorCode);
  static const Color validationErrorColor = Color(0xFFD31313);
  static const Color validationSuccessColor = Color(0xFF037E0B);
  static const Color validationSuccessColorLight = Color(0xFFE6F2E7);

  // splash colors
  static const int _primarySplashColorCode = 0xFFFF8331;
  static const Color primarySplashColor = Color(_lightGreyColorCode);
  static const int _secondarySplashColorCode = 0xFFEBEBEB;
  static const Color secondarySplashColor = Color(_lightGreyColorCode);

  // Other colors
  static const int _whiteColorCode = 0xFFFFFFFF;
  static const Color whiteColor = Color(_whiteColorCode);
  static const int _blackColorCode = 0xFF000000;
  static const Color blackColor = Color(_blackColorCode);
  static const int _bronzeColorCode = 0xFFC99B09;
  static const Color bronzeColor = Color(_bronzeColorCode);
  static const int _purpleColorCode = 0xFF7D3EE4;
  static const Color purpleColor = Color(_purpleColorCode);
  static const Color primaryPurple = Color(0xFF5C0FD9);
  static const Color ratingYellow = Color(0xFFF5BB00);

  //new colors

  static const Color icColor = Color(0xFF656565);
  static const Color themeColor = Color(0xFFF3B41B);
  static const Color forgotPassColor = Color(0xFFAEAEAE);
  static const Color gradient1 = Color(0xFF42BFB7);
  static const Color gradient2 = Color(0xFFB7CC57);
  static const Color gradient3 = Color(0xFFFCCE18);
  static const Color gradient4 = Color(0xFFF36E29);
  static const Color dashboardTopBg = Color(0xFFD5FFE7);
  static const Color dashboardRed = Color(0xFFF0592E);
  static const Color dashboardYellow = Color(0xFFFED217);
  static const Color dashboardTeal = Color(0xFF42BFB7);
  static const Color dashboardGrey = Color(0xFF867983);
  static const Color dashboardDarkGrey = Color(0xFF283233);
  static const Color navigationRed = Color(0xFFDC3546);
  static const Color profileBG = Color(0xFF5EBCDD);
  static const Color profileYellow = Color(0xFFFED11E);
  static const Color gratitudeBg = Color(0xFFF9CDAA);
  static const Color gratitudeButtonBg = Color(0xFFF3B31E);
  static const Color gratitudeOrange = Color(0xFFFB4104);
  static const Color gratitudePink = Color(0xFFFF473F);
  static const Color textFieldBG = Color(0xFFFFCED3);
  static const Color textColor = Color(0xFF2F2F2F);
  static const Color btnColor = Color(0xFF68B7B0);

}
abstract class Dimension {
  Dimension._();

  static const _scaleFactor = 4.0;
  static const d0 = 0.0;
  static const d0_25 = _scaleFactor * 0.25;
  static const d0_50 = _scaleFactor * 0.50;
  static const d0_75 = _scaleFactor * 0.75;
  static const d1 = _scaleFactor * 1;
  static const d1_50 = _scaleFactor * 1.50;
  static const d2 = _scaleFactor * 2;
  static const d2_50 = _scaleFactor * 2.50;
  static const d3 = _scaleFactor * 3;
  static const d4 = _scaleFactor * 4;
  static const d4_50 = _scaleFactor * 4.50;
  static const d5 = _scaleFactor * 5;
  static const d6 = _scaleFactor * 6;
  static const d7 = _scaleFactor * 7;
  static const d8 = _scaleFactor * 8;
  static const d9 = _scaleFactor * 9;
  static const d10 = _scaleFactor * 10;
  static const d11 = _scaleFactor * 11;
  static const d12 = _scaleFactor * 12;
  static const d13 = _scaleFactor * 13;
  static const d14 = _scaleFactor * 14;
  static const d15 = _scaleFactor * 15;
  static const d16 = _scaleFactor * 16;
  static const d17 = _scaleFactor * 17;
  static const d18 = _scaleFactor * 18;
  static const d19 = _scaleFactor * 19;
  static const d20 = _scaleFactor * 20;
  static const d22 = _scaleFactor * 22;
  static const d24 = _scaleFactor * 24;
  static const d26 = _scaleFactor * 26;
  static const d28 = _scaleFactor * 28;
  static const d30 = _scaleFactor * 30;
  static const d32 = _scaleFactor * 32;
  static const d34 = _scaleFactor * 34;
  static const d36 = _scaleFactor * 36;
  static const d38 = _scaleFactor * 38;
  static const d40 = _scaleFactor * 40;
  static const d44 = _scaleFactor * 44;

  static const d48 = _scaleFactor * 48;
  static const d58 = _scaleFactor * 58;
  static const d60 = _scaleFactor * 60;
  static const d64 = _scaleFactor * 64;
  static const d68 = _scaleFactor * 68;
  static const d82 = _scaleFactor * 82;
  static const d88 = _scaleFactor * 88;
  static const d90 = _scaleFactor * 90;
}
