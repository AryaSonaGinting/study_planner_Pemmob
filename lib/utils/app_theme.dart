import 'package:flutter/material.dart';

import 'constants.dart';

/// Warna-warna aplikasi. Dasarnya hitam-putih-abu,
/// hanya status yang memakai warna sederhana sebagai indikator.
class AppColors {
  AppColors._();

  // Warna dasar
  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA); // putih hampir putih
  static const Color textSecondary = Color(0xFF6B6B6B); // abu-abu teks
  static const Color border = Color(0xFFE0E0E0); // abu-abu muda
  static const Color disabled = Color(0xFFBDBDBD);

  // Warna indikator status (dipakai mulai Tahap 7/8)
  static const Color statusNotStarted = Color(0xFF9E9E9E); // abu-abu
  static const Color statusInProgress = Color(0xFF1E88E5); // biru
  static const Color statusCompleted = Color(0xFF43A047); // hijau
  static const Color statusCancelled = Color(0xFFE53935); // merah

  // Warna indikator prioritas
  static const Color priorityLow = Color(0xFF43A047);
  static const Color priorityMedium = Color(0xFFFB8C00);
  static const Color priorityHigh = Color(0xFFE53935);
}

/// Satu theme utama aplikasi (Material 3).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.black,
      onPrimary: AppColors.white,
      secondary: AppColors.textSecondary,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
      outline: AppColors.border,
      error: AppColors.statusCancelled,
    );

    final borderRadius = BorderRadius.circular(AppRadius.md);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // Teks
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ).apply(bodyColor: AppColors.black, displayColor: AppColors.black),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card: putih, border abu-abu muda, tanpa bayangan
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Tombol
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.black,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.black),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),

      // Input / TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.statusCancelled),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: AppColors.statusCancelled,
            width: 1.5,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
      ),

      // Navigasi bawah (mobile)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.black,
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.white : AppColors.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? AppColors.black : AppColors.textSecondary,
          );
        }),
      ),

      // Navigasi samping (web/desktop)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.black,
        selectedIconTheme: const IconThemeData(color: AppColors.white),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.textSecondary,
        ),
        selectedLabelTextStyle: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: AppColors.textSecondary,
        ),
      ),

      // Slider & progress bar
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.black,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.black,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.black,
        linearTrackColor: AppColors.border,
      ),

      // Garis pemisah
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.black,
        contentTextStyle: const TextStyle(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }
}
