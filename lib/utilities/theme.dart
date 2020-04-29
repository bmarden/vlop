import 'package:flutter/material.dart';
import 'package:vlop/utilities/constants.dart';

final kThemeData = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    buttonTheme: base.buttonTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
  );
}
