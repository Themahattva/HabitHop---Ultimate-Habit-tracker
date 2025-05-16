import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Violet color palette
  static const primaryColor = Color(0xFF9C27B0);  // Deep violet
  static const accentColor = Color(0xFFE1BEE7);   // Light violet
  static const backgroundColor = Color(0xFF1A1625); // Dark violet background
  static const surfaceColor = Color(0xFF2D253A);   // Slightly lighter violet
  static const cardColor = Color(0xFF352B44);      // Card background violet
  
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: Colors.white.withOpacity(0.87),
        displayColor: Colors.white,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        onBackground: Colors.white70,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor.withOpacity(0.7),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor.withOpacity(0.7),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white60,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  static BoxDecoration glassDecoration({
    double borderRadius = 16.0,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: surfaceColor.withOpacity(opacity),
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static Widget glassContainer({
    required Widget child,
    double borderRadius = 16.0,
    double opacity = 0.1,
    double blurAmount = 10.0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: Container(
          decoration: glassDecoration(
            borderRadius: borderRadius,
            opacity: opacity,
          ),
          child: child,
        ),
      ),
    );
  }

  // Helper method for gradient text
  static Widget gradientText(
    String text,
    TextStyle style, {
    Gradient? gradient,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => (gradient ?? 
        LinearGradient(
          colors: [
            primaryColor,
            accentColor.withOpacity(0.8),
          ],
        )).createShader(bounds),
      child: Text(text, style: style),
    );
  }

  // Predefined gradients for use in the app
  static final violetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryColor,
      primaryColor.withOpacity(0.7),
      accentColor.withOpacity(0.5),
    ],
  );

  // Enhanced glass effect for special containers
  static Widget enhancedGlassContainer({
    required Widget child,
    double borderRadius = 16.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: glassContainer(
        child: child,
        borderRadius: borderRadius,
        opacity: 0.15,
        blurAmount: 15.0,
      ),
    );
  }
} 