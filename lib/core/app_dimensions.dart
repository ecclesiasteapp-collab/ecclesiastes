import 'package:flutter/material.dart';

class AppDimensions {
  static double contentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 400; // Centered on tablets/web
    return width;
  }

  static double horizontalMargin(BuildContext context) {
    return 24.0;
  }

  static const double verticalPadding = 40.0;
  
  static const double loginLogoSize = 120.0;
  static const double loginLogoBorderSize = 2.0;
  
  static const double loginTitleFontSize = 24.0;
  static const double loginSubtitleFontSize = 14.0;
  static const double loginLinkFontSize = 14.0;
  static const double loginFooterFontSize = 12.0;
  
  static const double loginElementSpacing = 20.0;
  static const double loginSectionSpacing = 30.0;
  static const double loginDecorativeLineHeight = 1.5;
  
  static const double loginInputFieldBorderRadius = 8.0;
  static const double loginInputFieldBorderSize = 1.0;
  static const double loginDropdownSpacing = 12.0;
  
  static const double loginButtonHeight = 50.0;
  static const double loginButtonBorderRadius = 8.0;
  
  static const double loginLinkVerticalSpacing = 16.0;
  static const double loginFooterMarginTop = 40.0;
}

