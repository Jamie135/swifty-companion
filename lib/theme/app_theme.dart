import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App-wide theme: carbon grey background, fluorescent blue text.
ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: carbonGrey,
    colorScheme: base.colorScheme.copyWith(
      primary: fluorescentBlue,
      onPrimary: carbonGrey,
      secondary: fluorescentBlue,
      surface: carbonGrey,
      onSurface: fluorescentBlue,
      onSurfaceVariant: fluorescentBlue,
    ),
    textTheme: _buildTextTheme(base.textTheme).apply(
      bodyColor: fluorescentBlue,
      displayColor: fluorescentBlue,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: carbonGreyLight,
      foregroundColor: fluorescentBlue,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: fluorescentBlue,
      iconColor: fluorescentBlue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: carbonGreyLight,
        foregroundColor: fluorescentBlue,
        side: const BorderSide(color: fluorescentBlue),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: fluorescentBlue),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: fluorescentBlue),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: fluorescentBlue, width: 2),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: fluorescentBlue,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: fluorescentBlue,
      linearTrackColor: carbonGreyLight,
    ),
  );
}

/// Exo 2 for body text, Orbitron for titles and headings (incl. the app bar).
TextTheme _buildTextTheme(TextTheme base) {
  final body = GoogleFonts.exo2TextTheme(base);
  TextStyle orbitron(TextStyle? style) => GoogleFonts.orbitron(textStyle: style);
  return body.copyWith(
    displayLarge: orbitron(body.displayLarge),
    displayMedium: orbitron(body.displayMedium),
    displaySmall: orbitron(body.displaySmall),
    headlineLarge: orbitron(body.headlineLarge),
    headlineMedium: orbitron(body.headlineMedium),
    headlineSmall: orbitron(body.headlineSmall),
    titleLarge: orbitron(body.titleLarge),
  );
}
