import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final Function onPressed;

  Button({
    Key key,
    @required this.child,
    this.color = const Color(0xFFF9AA33),
    this.width = 140.0,
    this.height = 96.0,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 3.0,
        onPressed: onPressed,
        color: color,
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
