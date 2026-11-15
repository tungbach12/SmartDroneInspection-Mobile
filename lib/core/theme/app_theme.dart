import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Material 3 design tokens aligned with SmartDroneInspection's Precision Daylight
/// visual system: Luminous Azure (#2563EB / #2B84EB), Optical Iris Teal (#0EA5E9 /
/// #14B8A6), slate-tinted daylight canvas (#F6F8FC), and tailored Slate Night dark theme.
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryBright = Color(0xFF2B84EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color skyAccent = Color(0xFF0EA5E9);
  static const Color mintTeal = Color(0xFF14B8A6);
  static const Color irisTeal = Color(0xFF2DD4BF);
  static const Color primarySoft = Color(0xFFEFF6FF);

  static const Color lightCanvas = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInset = Color(0xFFF1F5FA);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderStrong = Color(0xFFCBD5E1);
  static const Color lightInk = Color(0xFF0F172A);
  static const Color lightMuted = Color(0xFF475569);

  static const Color darkCanvas = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkRaised = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF1F2937);
  static const Color darkBorderStrong = Color(0xFF334155);
  static const Color darkInk = Color(0xFFF8FAFC);
  static const Color darkMuted = Color(0xFF94A3B8);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);

  static LinearGradient get brandActionGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, skyAccent],
  );

  static List<BoxShadow> cardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.28),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
    }
    return [
      BoxShadow(
        color: lightInk.withValues(alpha: 0.045),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: primary.withValues(alpha: 0.03),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primarySoft,
      onPrimaryContainer: primaryDark,
      secondary: skyAccent,
      onSecondary: Colors.white,
      tertiary: mintTeal,
      onTertiary: Colors.white,
      surface: lightSurface,
      onSurface: lightInk,
      onSurfaceVariant: lightMuted,
      surfaceContainerLowest: lightSurface,
      surfaceContainerLow: lightInset,
      surfaceContainer: lightCanvas,
      surfaceContainerHigh: const Color(0xFFE9EFF7),
      outline: lightBorderStrong,
      outlineVariant: lightBorder,
      error: danger,
    );
    return _build(
      scheme,
      scaffoldBg: lightCanvas,
      borderColor: lightBorder,
      strongBorderColor: lightBorderStrong,
      inkColor: lightInk,
      mutedColor: lightMuted,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primaryBright,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF172554),
      onPrimaryContainer: const Color(0xFFBFDBFE),
      secondary: skyAccent,
      onSecondary: darkCanvas,
      tertiary: irisTeal,
      onTertiary: darkCanvas,
      surface: darkSurface,
      onSurface: darkInk,
      onSurfaceVariant: darkMuted,
      surfaceContainerLowest: darkCanvas,
      surfaceContainerLow: darkSurface,
      surfaceContainer: darkRaised,
      surfaceContainerHigh: const Color(0xFF283548),
      outline: darkBorderStrong,
      outlineVariant: darkBorder,
      error: const Color(0xFFEF4444),
    );
    return _build(
      scheme,
      scaffoldBg: darkCanvas,
      borderColor: darkBorder,
      strongBorderColor: darkBorderStrong,
      inkColor: darkInk,
      mutedColor: darkMuted,
    );
  }

  static ThemeData _build(
    ColorScheme scheme, {
    required Color scaffoldBg,
    required Color borderColor,
    required Color strongBorderColor,
    required Color inkColor,
    required Color mutedColor,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    final baseText = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
    ).textTheme;

    final textTheme = baseText.copyWith(
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: inkColor,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.45,
        color: inkColor,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: inkColor,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        color: inkColor,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: inkColor,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(color: inkColor, height: 1.4),
      bodyMedium: baseText.bodyMedium?.copyWith(color: inkColor, height: 1.42),
      bodySmall: baseText.bodySmall?.copyWith(color: mutedColor, height: 1.38),
      labelLarge: baseText.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBg,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface.withValues(alpha: isDark ? 0.96 : 0.98),
        foregroundColor: inkColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: inkColor,
          letterSpacing: -0.25,
        ),
        shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkRaised : lightInset,
        hintStyle: TextStyle(color: mutedColor.withValues(alpha: 0.8)),
        labelStyle: TextStyle(color: mutedColor, fontWeight: FontWeight.w500),
        prefixIconColor: mutedColor,
        suffixIconColor: mutedColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: scheme.primary.withValues(alpha: 0.42),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkColor,
          backgroundColor: scheme.surface,
          side: BorderSide(color: strongBorderColor),
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: isDark ? const Color(0xFF1E3A8A) : primarySoft,
        labelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: inkColor,
        ),
        shape: const StadiumBorder(),
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: isDark
            ? scheme.primary.withValues(alpha: 0.22)
            : primarySoft,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 23);
          }
          return IconThemeData(color: mutedColor, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: scheme.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            );
          }
          return TextStyle(
            color: mutedColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
