import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cartoon Neo-Brutalism Color Palette for "جمهورية قاع الهامور"
class BikiniColors {
  // Core Character & Environment Colors
  static const Color spongeYellow = Color(0xFFFEE12B);
  static const Color oceanBlue = Color(0xFF09203F);
  static const Color oceanDeep = Color(0xFF030B17);
  static const Color marineCyan = Color(0xFF00F5D4);
  static const Color krabsRed = Color(0xFFD62828);
  static const Color neonPink = Color(0xFFFF007F);
  static const Color sand = Color(0xFFF4E3B2);
  static const Color warmSand = Color(0xFFF9F1DC);
  
  // Extended Undersea Colors
  static const Color deepNavy = Color(0xFF04101F);
  static const Color bubbleBlue = Color(0xFF48CAE4);
  static const Color seaweedGreen = Color(0xFF2EC4B6);
  static const Color planktonOlive = Color(0xFF70E000);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color cartoonBlack = Color(0xFF141414);
  static const Color outlineDark = Color(0xFF000000);
  
  // Wooden Nautical Colors
  static const Color woodDark = Color(0xFF4E2211);
  static const Color woodBase = Color(0xFF824925);
  static const Color woodLight = Color(0xFFA56637);
  static const Color goldNail = Color(0xFFFFD166);

  // Gradients
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [oceanBlue, oceanDeep],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Neo-Brutalism Visual Utilities & Decorations
class BikiniDecorations {
  static const double borderWidth = 3.0;
  static const double borderRadius = 16.0;
  static const Offset shadowOffset = Offset(4, 4);
  static const Offset heroShadowOffset = Offset(5, 5);
  static const Offset pressedShadowOffset = Offset(1, 1);

  static BoxDecoration cartoonBox({
    Color backgroundColor = BikiniColors.pureWhite,
    double radius = borderRadius,
    double strokeWidth = borderWidth,
    Color borderColor = BikiniColors.cartoonBlack,
    Color shadowColor = BikiniColors.cartoonBlack,
    Offset shadow = shadowOffset,
    bool showShadow = true,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor,
        width: strokeWidth,
      ),
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: shadowColor,
                offset: shadow,
                blurRadius: 0,
              ),
            ]
          : null,
    );
  }

  static BoxDecoration cartoonPill({
    Color backgroundColor = BikiniColors.spongeYellow,
    double strokeWidth = 2.0,
    Color borderColor = BikiniColors.cartoonBlack,
    Offset shadow = const Offset(2, 2),
    bool showShadow = true,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: borderColor,
        width: strokeWidth,
      ),
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: BikiniColors.cartoonBlack,
                offset: shadow,
                blurRadius: 0,
              ),
            ]
          : null,
    );
  }

  static BoxDecoration woodenPlank({
    double radius = 12.0,
    double strokeWidth = 3.0,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          BikiniColors.woodBase,
          BikiniColors.woodLight,
          BikiniColors.woodBase,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: BikiniColors.cartoonBlack,
        width: strokeWidth,
      ),
      boxShadow: const [
        BoxShadow(
          color: BikiniColors.cartoonBlack,
          offset: Offset(4, 4),
          blurRadius: 0,
        ),
      ],
    );
  }
}

/// Cartoon Egyptian Typography
/// RULE: Lalezar is strictly restricted to large top display headers.
/// All body texts, card descriptions, comments, post contents, form fields, and badges use GoogleFonts.cairo()
/// with light/normal weights (FontWeight.w400 & FontWeight.w500) for crystal clear, light readability.
class BikiniTypography {
  // Bold Display Titles (Lalezar ONLY for top headers)
  static TextStyle displayLarge({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.lalezar(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle displayMedium({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.lalezar(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.25,
      );

  static TextStyle displaySmall({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.lalezar(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.3,
      );

  // Body & UI Labels (Cairo strictly w400, w500, w600 for light, crisp readability)
  static TextStyle titleBold({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.35,
      );

  static TextStyle titleMedium({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.35,
      );

  static TextStyle bodyBold({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyLarge({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyMedium({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyRegular({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.45,
      );

  static TextStyle caption({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.3,
      );

  static TextStyle captionBold({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.3,
      );

  static TextStyle inputLabel({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.3,
      );

  static TextStyle inputHint({Color color = const Color(0xFF777777)}) =>
      GoogleFonts.cairo(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.3,
      );

  static TextStyle tickerText({Color color = BikiniColors.cartoonBlack}) =>
      GoogleFonts.cairo(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.35,
      );
}

/// Complete ThemeData for the Application
class BikiniTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: BikiniColors.warmSand,
      primaryColor: BikiniColors.spongeYellow,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: BikiniColors.spongeYellow,
        onPrimary: BikiniColors.cartoonBlack,
        secondary: BikiniColors.marineCyan,
        onSecondary: BikiniColors.cartoonBlack,
        error: BikiniColors.krabsRed,
        onError: BikiniColors.pureWhite,
        surface: BikiniColors.pureWhite,
        onSurface: BikiniColors.cartoonBlack,
      ),
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: TextTheme(
        displayLarge: BikiniTypography.displayLarge(),
        displayMedium: BikiniTypography.displayMedium(),
        displaySmall: BikiniTypography.displaySmall(),
        headlineMedium: BikiniTypography.titleBold(),
        titleMedium: BikiniTypography.titleMedium(),
        bodyLarge: BikiniTypography.bodyLarge(),
        bodyMedium: BikiniTypography.bodyMedium(),
        bodySmall: BikiniTypography.bodyRegular(),
        labelSmall: BikiniTypography.caption(),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
