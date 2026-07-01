import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette ────────────────────────────────────────────────────────────────
  static const Color bgDeep       = Color(0xFF060818); // fondo principal
  static const Color bgCard       = Color(0xFF0D1117); // fondo cards
  static const Color glassWhite   = Color(0x14FFFFFF); // glass fill
  static const Color glassBorder  = Color(0x22FFFFFF); // glass border
  static const Color textPrimary  = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF8892A4);
  static const Color accentCyan   = Color(0xFF00E5FF);
  static const Color accentPurple = Color(0xFF7B2FFF);

  // Per-screen accent gradients
  static const gradientGender  = [Color(0xFF2979FF), Color(0xFFFF4081)];
  static const gradientAge     = [Color(0xFFFF6D00), Color(0xFFFFD600)];
  static const gradientUni     = [Color(0xFF00C853), Color(0xFF00BCD4)];
  static const gradientWeather = [Color(0xFF0288D1), Color(0xFF26C6DA)];
  static const gradientPokemon = [Color(0xFFE53935), Color(0xFFFFB300)];
  static const gradientWP      = [Color(0xFF0073AA), Color(0xFF21759B)];
  static const gradientAbout   = [Color(0xFF7B2FFF), Color(0xFF00E5FF)];
  static const gradientHome    = [Color(0xFF00E5FF), Color(0xFF7B2FFF)];

  // ── Typography ─────────────────────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.spaceGrotesk(
      fontSize: 36, fontWeight: FontWeight.w800,
      color: textPrimary, letterSpacing: -1,
    ),
    displayMedium: GoogleFonts.spaceGrotesk(
      fontSize: 28, fontWeight: FontWeight.w700,
      color: textPrimary, letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.spaceGrotesk(
      fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary,
    ),
    titleLarge: GoogleFonts.spaceGrotesk(
      fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary,
    ),
    labelLarge: GoogleFonts.spaceGrotesk(
      fontSize: 14, fontWeight: FontWeight.w600,
      color: accentCyan, letterSpacing: 0.5,
    ),
  );

  // ── Material Theme ──────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDeep,
    colorScheme: const ColorScheme.dark(
      surface: bgCard,
      primary: accentCyan,
      secondary: accentPurple,
      onPrimary: bgDeep,
      onSurface: textPrimary,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: glassWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: accentCyan, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentCyan,
        foregroundColor: bgDeep,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 15, fontWeight: FontWeight.w700,
        ),
        elevation: 0,
      ),
    ),
  );
}
