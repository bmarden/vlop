import 'package:flutter/material.dart';
import 'constants.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final Function onPressed;

  Button({
    Key key,
    @required this.child,
    this.color = Colors.blue,
    this.width = 85.0,
    this.height = 35.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: onPressed,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
