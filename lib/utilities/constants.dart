import 'package:flutter/material.dart';

final kHintText = TextStyle(
  color: Colors.white54,
  fontFamily: 'Manrope',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: 'Manrope',
);

final kSmallText = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Manrope',
);

final kDisplayStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 35.0,
  fontFamily: 'Manrope',
);

InputDecoration kPostInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
  );
}

final kBoxGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF232F34),
      Color(0xFF344955),
      Color(0xFF4A6572),
      Colors.blueGrey[400],
    ],
    stops: [0.1, 0.4, 0.7, 1.0],
  ),
);

// Custom InputDecoration for register/login forms
InputDecoration kInputDecoration(String hint, IconData icon) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Color(0xFFF9AA33)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.grey[600]),
    ),
    fillColor: Colors.blueGrey[400],
    filled: true,
    contentPadding: EdgeInsets.only(top: 14.0),
    prefixIcon: Icon(
      icon,
      color: Colors.grey[800],
    ),
    hintText: hint,
    hintStyle: kHintText,
  );
}
