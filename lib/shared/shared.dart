// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritammuddatask/controllers/providers.dart';

InputDecoration authTextInputDecoration(
    String label, IconData prefixIcon, String? preText, BuildContext context) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(20.0),
    fillColor: Theme.of(context).colorScheme.onInverseSurface,
    filled: true,
    prefixIcon: Icon(prefixIcon),
    prefixText: preText,
    labelText: label,
    labelStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: textFieldBorder(false, 30.0),
    focusedBorder: textFieldBorder(false, 30.0),
    errorBorder: textFieldBorder(false, 30.0),
    errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
  );
}

OutlineInputBorder textFieldBorder(bool border, double rad) {
  return OutlineInputBorder(
    // borderSide: border ? const BorderSide(width: 0.5) : BorderSide.none,
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(rad),
  );
}

ThemeData APP_THEME(WidgetRef ref) => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ref.watch(swatchColorProvider),
        brightness: ref.watch(swatchBrightnessProvider),
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
      fontFamily: GoogleFonts.montserrat().fontFamily,
    );

Map<String, Color> THEMES = <String, Color>{
  "Purple": Colors.deepPurple,
  "Orange": Colors.orange,
  "Red": Colors.red,
  "Amber": Colors.amber,
  "Teal": Colors.teal,
  "Blue": Colors.blue,
  "Grey": Colors.blueGrey,
  "Green": Colors.green,
  "Indigo": Colors.indigo,
};
