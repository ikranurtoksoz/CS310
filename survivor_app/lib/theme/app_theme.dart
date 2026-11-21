import 'package:flutter/material.dart';

class AppTheme {
  // Sakura & Navy color palette
  static const Color primaryColor = Color(0xFF20345C);
  static const Color primaryLight = Color(0xFF405780);
  static const Color accent = Color(0xFFE8A6BD);
  static const Color backgroundColor = Color(0xFFFDF7FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF20345C);
  static const Color textSecondary = Color(0xFF7D8298);
  static const Color divider = Color(0xFFF0DFE7);

  static const Color success = Color(0xFF438A72);
  static const Color warning = Color(0xFFE0A04B);
  static const Color danger = Color(0xFFC9485B);
  static const Color highlight = Color(0xFFF7DCE6);

  // Compatibility with existing screens
  static ThemeData get light => lightTheme;

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF7DCE6), Color(0xFFFDF7FA), Colors.white],
    stops: [0.0, 0.48, 1.0],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF20345C), Color(0xFF405780), Color(0xFFE8A6BD)],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accent,
        surface: surface,
        error: danger,
      ),

      scaffoldBackgroundColor: backgroundColor,
      dividerColor: divider,

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: highlight,
        indicatorColor: accent,
        dividerColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: divider),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: highlight,
        side: const BorderSide(color: divider),
        labelStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accent, width: 1.8),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: accent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: highlight,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? primaryColor
                : textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? primaryColor
                : textSecondary,
          ),
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}

// Compatibility with other existing screens
class AppColors {
  static const Color navy = AppTheme.primaryColor;
  static const Color primary = AppTheme.primaryColor;
  static const Color primaryColor = AppTheme.primaryColor;
  static const Color primaryLight = AppTheme.primaryLight;

  static const Color sakuraPink = AppTheme.accent;
  static const Color pink = AppTheme.accent;
  static const Color accent = AppTheme.accent;

  static const Color petalBlush = AppTheme.highlight;
  static const Color blush = AppTheme.highlight;
  static const Color highlight = AppTheme.highlight;

  static const Color softIvory = AppTheme.backgroundColor;
  static const Color background = AppTheme.backgroundColor;
  static const Color backgroundColor = AppTheme.backgroundColor;

  static const Color mutedSlate = AppTheme.textSecondary;
  static const Color textPrimary = AppTheme.textPrimary;
  static const Color textSecondary = AppTheme.textSecondary;

  static const Color surface = AppTheme.surface;
  static const Color divider = AppTheme.divider;
  static const Color success = AppTheme.success;
  static const Color warning = AppTheme.warning;
  static const Color danger = AppTheme.danger;
}

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
