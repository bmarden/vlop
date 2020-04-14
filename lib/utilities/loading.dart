import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF398AE5),
      child: Center(
        child: SpinKitCircle(
          color: Colors.grey[900],
          size: 60.0,
        ),
      ),
    );
  }
}
