import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  static bool isSmallScreen(BuildContext context) => width(context) < 350;
  static bool isTablet(BuildContext context) => width(context) >= 600;

  /// Scalable pixels for font sizes
  static double sp(BuildContext context, double size) {
    double scaleFactor = width(context) / 375; // Standard design width
    return size * scaleFactor;
  }

  /// Percentage based width
  static double pw(BuildContext context, double percentage) {
    return width(context) * (percentage / 100);
  }

  /// Percentage based height
  static double ph(BuildContext context, double percentage) {
    return height(context) * (percentage / 100);
  }
}
