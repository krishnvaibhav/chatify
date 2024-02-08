import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData().copyWith(
  // ignore: deprecated_member_use
  useMaterial3: true,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    bodyMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.normal,
      fontSize: 18
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      fontSize: 24
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
        fontWeight: FontWeight.bold,
        fontSize: 30
    ),
  ),
);