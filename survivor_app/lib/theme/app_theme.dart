import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SUrvivor palette (Sabancı Navy + Sakura Pink), Plus Jakarta Sans,
/// soft gradient backgrounds. Shared by every screen.
class AppTheme {
  // Core palette (Sabancı blue tones)
  static const Color primaryColor = Color(0xFF20345C); // Sabancı Navy
  static const Color primaryLight = Color(0xFF3B5486);
  static const Color accent = Color(0xFFE8A6BD); // Sakura Pink
  static const Color accentStrong = Color(0xFFDB7FA0); // deeper sakura for text/icons
  static const Color backgroundColor = Color(0xFFFDF7FA); // Soft Ivory
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF20345C);
  static const Color textSecondary = Color(0xFF7D8298); // Muted Slate
  static const Color divider = Color(0xFFE2E4EA); // Cool Gray tint

  // Semantic colours
  static const Color success = Color(0xFF2E8B57);
  static const Color warning = Color(0xFFE09E3C);
  static const Color danger = Color(0xFFC94A6A);
  static const Color coolGray = Color(0xFFA9ADBA);
  static const Color highlight = Color(0xFFF7DCE6); // Petal Blush

  /// Subtle page gradient (top → bottom).
  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF7DCE6), Color(0xFFFBEDF2), Color(0xFFFDF7FA)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Header gradient for app bars and hero cards.
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF20345C), Color(0xFF3B5486), Color(0xFFE8A6BD)],
    stops: [0.0, 0.55, 1.0],
  );

  /// Sakura hero gradient (welcome / splash).
  static const LinearGradient sakuraGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8A6BD), Color(0xFFF7DCE6), Color(0xFFFDF7FA)],
    stops: [0.0, 0.55, 1.0],
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
        unselectedLabelColor: Color(0xFFA9ADBA),
        indicatorColor: Color(0xFFE8A6BD),
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
        selectedColor: accent,
        side: const BorderSide(color: divider),
        checkmarkColor: primaryColor,
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
          borderSide: const BorderSide(color: accentStrong, width: 1.8),
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
          side: const BorderSide(color: accentStrong, width: 1.6),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accentStrong),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected)
                ? primaryColor
                : coolGray)),
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

/// Round sakura brand mark used on splash / welcome / auth screens.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8A6BD), Color(0xFFDB7FA0)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8A6BD).withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(Icons.local_florist_rounded,
          size: size * 0.55, color: Colors.white),
    );
  }
}
