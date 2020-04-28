import 'package:flutter/material.dart';
import 'constants.dart';

class Button extends StatelessWidget {
  final buttonText;
  final Function buttonAction;
  final bool asyncAction;
  Button({
    @required this.buttonText,
    @required this.buttonAction,
    @required this.asyncAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 140.0,
      height: 96.0,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: asyncAction
            ? () async {
                await buttonAction();
              }
            : buttonAction(),
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.grey[800],
        child: Text(
          buttonText,
          style: kLabelStyle,
        ),
      ),
    );
  }
}
