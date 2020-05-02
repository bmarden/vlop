import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:vlop/utilities/constants.dart';
import 'package:vlop/utilities/loading.dart';

class Login extends StatefulWidget {
  // Declare the function from auth_view. Will be used to change to register screen
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // AuthService instance to get Firebase Auth access
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _pass;

  // Local variables
  bool _loading = false;
  bool _validateState = false;
  String _email;

  @override
  void initState() {
    _pass = TextEditingController();
    _pass.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  bool validateForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> submitForm() async {
    // setState(() => _loading = true);
    if (validateForm()) {
      dynamic result = await _auth.signInUserWithEmail(_email, _pass.text);
      if (result == null) {
        print("Error: Couldn't login poop");
        setState(() => _loading = false);
        _buildErrorDialog(context, "Couldn't login");
      } else {
        setState(() => _validateState = true);
      }
    } else {
      setState(() {
        _loading = false;
        _validateState = false;
      });
    }
  }

  Widget _emailTB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        TextFormField(
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: kInputDecoration('Enter your email', Icons.mail),
          validator: (value) {
            if (!isEmail(value.trim())) {
              return 'Enter a valid email';
            }
            return null;
          },
          onSaved: (value) => _email = value.trim(),
        ),
      ],
    );
  }

  Widget _passwordTB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _pass,
          obscureText: true,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: kInputDecoration('Enter a password', Icons.lock),
          onSaved: (val) {
            _pass.text = val.trim();
          },
        ),
      ],
    );
  }

  Widget _submitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 140.0,
      height: 96.0,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () async {
          await submitForm();
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.grey[800],
        child: Text(
          'Submit',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _switchToRegister() {
    return RichText(
      text: TextSpan(
        text: 'Need an account? ',
        style: TextStyle(fontSize: 14),
        children: [
          TextSpan(
              text: 'Sign up Here!',
              style: kSmallText,
              recognizer: TapGestureRecognizer()
                ..onTap = () => widget.toggleView()),
        ],
      ),
    );
  }

  void _buildErrorDialog(BuildContext context, _message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidate: _validateState,
                  child: Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 100.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _emailTB(),
                          SizedBox(height: 25.0),
                          _passwordTB(),
                          _submitBtn(),
                          _switchToRegister(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
