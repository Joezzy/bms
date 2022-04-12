import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTheme {
  static const Color primaryColor = Color(0xffE2AD24);
  static const Color heventhBlue = Color(0xFF2A2C8F);
  static const Color heventhGrey = Color(0xFFEBEBEB);
  static const Color secondaryColor = Color(0xFFF1F4F8);
  static const Color lightGrey = Color(0xFFC4C4C4);
  static const Color tertiaryColor = Color(0xFF8B97A2);
  static const Color darkBackground = Color(0xFF26323F);
  static const Color lighterBackground = Color(0xFF415367);
  static const Color whiteBackground = Color(0xFFFFFFFF);
  static const Color disabledButtonColor = Color(0xFF434D57);
  static const Color disabledButtonTextColor = Color(0xFF1C2733);
  static const Color inputBackgroundColor = Color(0xFFC4C4C4);
  static const Color textLightGrey = Color(0xFF91A5BB);
  static const Color textDarkGrey = Color(0xFF909090);

  static TextStyle get title1 => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 36,
  );
  static TextStyle get title2 => TextStyle(
    color: Color(0xFF303030),
    fontWeight: FontWeight.w500,
    fontSize: 22,
  );
  static TextStyle get title3 => TextStyle(
    color: Color(0xFF303030),
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
  static TextStyle get subtitle1 => TextStyle(
    color: secondaryColor,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  static TextStyle get subtitle2 => TextStyle(
    color: Color(0xFF616161),
    fontWeight: FontWeight.normal,
    fontSize: 16,
  );
  static TextStyle get bodyText1 => TextStyle(
    color: tertiaryColor,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );
  static TextStyle get bodyText2 => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );
  static TextStyle get bodyText3 => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  static TextStyle get subStyle => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14
  );

  static TextStyle buttonWhiteTextStyle(
      {Color color = Colors.black,
        double fontSize = 14,
        FontWeight fontWeight = FontWeight.normal,
        double lineHeight = 1.35}) {
    return TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        height: lineHeight);
  }

  static Color darken(Color color, {double amount = .08}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    HSLColor hslDark =
    hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    // hslDark = hslDark.withHue(hslDark.hue - amount);
    // hslDark = hslDark.withSaturation(hslDark.saturation - amount);
    return hslDark.toColor();
  }

  static Color lighten(Color color, {double amount = .08}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
    hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static String money(double amount, {int digits = 0}) {
    return NumberFormat.currency(
        symbol: '₦', locale: 'en-UK', decimalDigits: digits)
        .format(amount);
  }

  static double readMoney(String text, {int digits = 0}) {
    // if (double.tryParse(text) == null) return 0;
    return NumberFormat.currency(
        symbol: '₦', locale: 'en-UK', decimalDigits: digits)
        .parse(text)
        .toDouble();
  }
}

extension TextStyleHelper on TextStyle {
  TextStyle override(
      {Color? color,
        double? fontSize,
        FontWeight? fontWeight,
        FontStyle? fontStyle}) =>
      TextStyle(
        color: color ?? this.color,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle,
      );
}
