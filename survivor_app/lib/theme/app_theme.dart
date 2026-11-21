import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sabancı University blue palette, Plus Jakarta Sans typography,
/// soft gradient backgrounds. Shared by every screen.
class AppTheme {
  // Core palette (Sabancı blue tones)
  static const Color primaryColor = Color(0xFF003B71); // SU navy
  static const Color primaryLight = Color(0xFF1F5FA8);
  static const Color accent = Color(0xFF4FA3E0); // sky
  static const Color backgroundColor = Color(0xFFF3F7FC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF14233A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color divider = Color(0xFFDCE6F2);

  // Semantic colours
  static const Color success = Color(0xFF2E8B57);
  static const Color warning = Color(0xFFE09E3C);
  static const Color danger = Color(0xFFC9485B);
  static const Color highlight = Color(0xFFE3EEF9);

  /// Subtle page gradient (top → bottom).
  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEAF2FB), Color(0xFFF8FBFE), Colors.white],
    stops: [0.0, 0.45, 1.0],
  );

  /// Header gradient for app bars and hero cards.
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF002B55), Color(0xFF003B71), Color(0xFF1F5FA8)],
  );

  static ThemeData get lightTheme {
    final base = ThemeData(useMaterial3: true);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: textPrimary, displayColor: textPrimary);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accent,
        surface: surface,
        error: danger,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      dividerColor: divider,

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFFB7CDE6),
        indicatorColor: Color(0xFF4FA3E0),
        dividerColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: highlight,
        side: const BorderSide(color: divider),
        labelStyle: textTheme.labelLarge?.copyWith(color: textPrimary),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLight, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: primaryColor),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryLight),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: highlight,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected)
                ? primaryColor
                : textSecondary)),
        labelTextStyle: WidgetStateProperty.resolveWith((s) =>
            (textTheme.labelSmall ?? const TextStyle()).copyWith(
              fontWeight: s.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: s.contains(WidgetState.selected)
                  ? primaryColor
                  : textSecondary,
            )),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Wraps a page body with the shared soft gradient.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
      child: child,
    );
  }
}
