import 'package:flutter/material.dart';

final kThemeData = _buildTheme();

ThemeData _buildTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    primaryColor: Color(0xFF344955),
    accentColor: Color(0xFFF9AA33),
    buttonTheme: base.buttonTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      buttonColor: Color(0xFFF9AA33),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFF9AA33),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.blueGrey[800],
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(
          fontWeight: FontWeight.w500,
        ),
        headline6: base.headline6.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(fontFamily: 'Manrope');
}
