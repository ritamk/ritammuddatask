import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isOnLoginScreenProvider =
    StateProvider((ref) => true);

final StateProvider<Color> swatchColorProvider =
    StateProvider<Color>((ref) => Colors.deepPurple);

final StateProvider<Brightness> swatchBrightnessProvider =
    StateProvider<Brightness>((ref) => Brightness.light);
