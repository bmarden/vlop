import 'package:flutter/material.dart';

final kHintText = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
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
  fontFamily: 'OpenSans',
);

final kBoxStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(14.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: <Color>[
      Color(0xFF73AEF5),
      Color(0xFF61A4F1),
      Color(0xFF478DE0),
      Color(0xFF398AE5),
    ],
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
      borderSide: BorderSide(color: Colors.blue[100]),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.grey[600]),
    ),
    fillColor: Color(0xFF6CA8F1),
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
