import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cartoon Neo-Brutalism Color Palette for "جمهورية قاع الهامور"
/// Strictly matching .agent/02-ui-system.md
class BikiniColors {
  // 12 Core Theme Tokens
  static const Color deep = Color(0xFF0E3A46);       // Top bar and main headers
  static const Color deep2 = Color(0xFF16505F);      // Elements inside top bar
  static const Color action = Color(0xFFFFC531);     // Primary action button ONLY (one per screen)
  static const Color support = Color(0xFF1FB6A6);    // Active tab, selected state, "available"
  static const Color alert = Color(0xFFE5194B);      // Live, breaking news, notification count
  static const Color danger = Color(0xFFC42B2B);     // Delete, kick, report only
  static const Color coin = Color(0xFFC9922B);       // Shells and prices only
  static const Color paper = Color(0xFFF7EDD8);      // Screen background (warm sand paper)
  static const Color card = Color(0xFFFFFDF7);       // Card surfaces
  static const Color ink = Color(0xFF14202B);        // Text and solid 2px borders
  static const Color muted = Color(0xFF6B7A7E);      // Secondary/helper text
  static const Color line = Color(0xFFD9CBAE);       // Dividers and borders

  // Species Colors (Avatar and species badges ONLY)
  static const Color sponge = Color(0xFFFFD93D);
  static const Color starfish = Color(0xFFFF8FA3);
  static const Color squid = Color(0xFFA78BD9);
  static const Color crab = Color(0xFFF26B4E);
  static const Color squirrel = Color(0xFFB07A4B);
  static const Color fish = Color(0xFF4FA9D8);
}

/// System Spacing Tokens as defined in 02-ui-system.md (4, 8, 12, 16, 24, 32)
class BikiniSpacing {
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
}

/// System Border Radii as defined in 02-ui-system.md
class BikiniRadius {
  static const double card = 16.0;
  static const double button = 12.0;
  static const double sheet = 24.0;
  static const double pill = 999.0;

  static const double navBarClearance = 88.0;
  static const double minTapHeight = 46.0;
  static const double screenMargin = 16.0;
  static const double borderWidth = 2.0;
}

/// Neo-Brutalism Visual Utilities & Decorations
/// RULE: Solid shadow 3px 3px 0 means "THIS IS PRESSABLE / INTERACTIVE".
/// Non-interactive elements have NO shadow.
class BikiniDecorations {
  static const double borderWidth = BikiniRadius.borderWidth;
  static const double borderRadius = BikiniRadius.card;
  static const Offset shadowOffset = Offset(3, 3);
  static const Offset pressedShadowOffset = Offset(1, 1);

  /// Interactive Card / Box with 3px solid pressable shadow
  static BoxDecoration interactiveCard({
    Color backgroundColor = BikiniColors.card,
    double radius = BikiniRadius.card,
    double strokeWidth = BikiniRadius.borderWidth,
    Color borderColor = BikiniColors.ink,
    Color shadowColor = BikiniColors.ink,
    Offset shadow = shadowOffset,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor,
        width: strokeWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: shadow,
          blurRadius: 0,
        ),
      ],
    );
  }

  /// Static Non-Interactive Card with NO shadow
  static BoxDecoration staticCard({
    Color backgroundColor = BikiniColors.card,
    double radius = BikiniRadius.card,
    double strokeWidth = BikiniRadius.borderWidth,
    Color borderColor = BikiniColors.ink,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor,
        width: strokeWidth,
      ),
    );
  }

  /// General purpose cartoon box (interactive when showShadow = true)
  static BoxDecoration cartoonBox({
    Color backgroundColor = BikiniColors.card,
    double radius = BikiniRadius.card,
    double strokeWidth = BikiniRadius.borderWidth,
    Color borderColor = BikiniColors.ink,
    Color shadowColor = BikiniColors.ink,
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

  /// Cartoon Pill Badge / Chip
  static BoxDecoration cartoonPill({
    Color backgroundColor = BikiniColors.card,
    double strokeWidth = BikiniRadius.borderWidth,
    Color borderColor = BikiniColors.ink,
    Offset shadow = const Offset(2, 2),
    bool showShadow = false,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(BikiniRadius.pill),
      border: Border.all(
        color: borderColor,
        width: strokeWidth,
      ),
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: BikiniColors.ink,
                offset: shadow,
                blurRadius: 0,
              ),
            ]
          : null,
    );
  }
}

/// Cartoon Typography scale strictly conforming to 02-ui-system.md
/// RULE: Lalezar is strictly restricted to large top display headers (>= 18px).
/// All other texts use Cairo with weights 400, 600, 700 (for h3 only), 800.
/// All Arabic styles have height: 1.7. Minimum font size is 11.5px.
class BikiniTypography {
  // 1. Display Header (Lalezar 28)
  static TextStyle display({Color color = BikiniColors.ink}) =>
      GoogleFonts.lalezar(
        fontSize: 28,
        color: color,
        height: 1.7,
      );

  // 2. Headings Scale
  // h1: Cairo 800 / 22
  static TextStyle h1({Color color = BikiniColors.ink}) =>
      GoogleFonts.cairo(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.7,
      );

  // h2: Cairo 800 / 19
  static TextStyle h2({Color color = BikiniColors.ink}) =>
      GoogleFonts.cairo(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.7,
      );

  // h3: Cairo 700 / 16.5
  static TextStyle h3({Color color = BikiniColors.ink}) =>
      GoogleFonts.cairo(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.7,
      );

  // 3. Body Text (Cairo 400 / 15)
  static TextStyle body({Color color = BikiniColors.ink}) =>
      GoogleFonts.cairo(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.7,
      );

  // 4. Label (Cairo 600 / 13.5)
  static TextStyle label({Color color = BikiniColors.ink}) =>
      GoogleFonts.cairo(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.7,
      );

  // 5. Caption (Cairo 600 / 11.5)
  static TextStyle caption({Color color = BikiniColors.muted}) =>
      GoogleFonts.cairo(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.7,
      );

  // 6. Monospace for codes, national IDs, and balances (Share Tech Mono 13)
  static TextStyle mono({Color color = BikiniColors.ink}) =>
      GoogleFonts.shareTechMono(
        fontSize: 13,
        color: color,
        height: 1.7,
      );

  // -------------------------------------------------------------
  // Backward-compatibility scale mappings strictly respecting rules
  // -------------------------------------------------------------
  static TextStyle displayLarge({Color color = BikiniColors.ink}) => display(color: color);
  static TextStyle displayMedium({Color color = BikiniColors.ink}) => h1(color: color);
  static TextStyle displaySmall({Color color = BikiniColors.ink}) => h2(color: color);

  static TextStyle titleBold({Color color = BikiniColors.ink}) => h3(color: color);
  static TextStyle titleMedium({Color color = BikiniColors.ink}) => h3(color: color);

  static TextStyle bodyLarge({Color color = BikiniColors.ink}) => body(color: color);
  static TextStyle bodyMedium({Color color = BikiniColors.ink}) => body(color: color);
  static TextStyle bodyRegular({Color color = BikiniColors.ink}) => body(color: color);
  static TextStyle bodyBold({Color color = BikiniColors.ink}) => label(color: color);

  static TextStyle captionBold({Color color = BikiniColors.ink}) => caption(color: color);

  static TextStyle inputLabel({Color color = BikiniColors.ink}) => label(color: color);
  static TextStyle inputHint({Color color = BikiniColors.muted}) => caption(color: color);
  static TextStyle tickerText({Color color = BikiniColors.ink}) => label(color: color);
}

/// Complete ThemeData for the Application
class BikiniTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: BikiniColors.paper,
      primaryColor: BikiniColors.action,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: BikiniColors.action,
        onPrimary: BikiniColors.ink,
        secondary: BikiniColors.support,
        onSecondary: BikiniColors.ink,
        error: BikiniColors.danger,
        onError: BikiniColors.card,
        surface: BikiniColors.card,
        onSurface: BikiniColors.ink,
      ),
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: TextTheme(
        displayLarge: BikiniTypography.display(),
        displayMedium: BikiniTypography.h1(),
        displaySmall: BikiniTypography.h2(),
        headlineMedium: BikiniTypography.h3(),
        titleMedium: BikiniTypography.h3(),
        bodyLarge: BikiniTypography.body(),
        bodyMedium: BikiniTypography.label(),
        bodySmall: BikiniTypography.caption(),
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

