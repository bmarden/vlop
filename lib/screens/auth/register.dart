import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:vlop/utilities/constants.dart';
import 'package:vlop/utilities/loading.dart';
import 'package:vlop/utilities/widgets.dart';

class Register extends StatefulWidget {
  // Declare the function from auth_view. Will be used to change to login screen
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String _email;
  String _userName;
  bool _loading = false;
  bool _validateState = false;
  String error = '';

  @override
  void dispose() {
    _pass.dispose();
    _confirmPass.dispose();
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

  void submitForm() async {
    setState(() => _loading = true);
    if (validateForm()) {
      dynamic result = _auth.registerNewUser(_email, _userName, _pass.text);
      if (result == null) {
        print("ERROR: couldn't register user");
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

  Widget _userNameTB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'User Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        TextFormField(
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: kInputDecoration('Enter a user name', Icons.person),
          validator: (value) {
            if (value.isEmpty) {
              return "User name can't be empty";
            }
            return null;
          },
          onSaved: (value) => _userName = value.trim(),
        ),
      ],
    );
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

  Widget _passwordTB(bool confirmPwd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          confirmPwd ? 'Confirm Password' : 'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: confirmPwd ? _confirmPass : _pass,
          obscureText: true,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: kInputDecoration('Enter a password', Icons.lock),
          validator: (String value) {
            if (confirmPwd) {
              if (_pass.text != _confirmPass.text) {
                return 'Passwords must match';
              }
            } else {
              if (value.length < 6) {
                return 'Password must be longer than 6 characters';
              }
            }
            return null;
          },
          onSaved: (val) {
            if (confirmPwd) {
              _pass.text = val.trim();
            } else {
              _confirmPass.text = val.trim();
            }
          },
        ),
      ],
    );
  }

  Widget _switchToSignIn() {
    return RichText(
      text: TextSpan(
        text: 'Already have an account? ',
        style: TextStyle(fontSize: 16),
        children: [
          TextSpan(
            text: 'Sign in Here!',
            style: kSmallText,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.toggleView();
              },
          ),
        ],
      ),
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
                  decoration: kBoxGradient,
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
                            'Register',
                            style: kDisplayStyle,
                          ),
                          SizedBox(height: 25.0),
                          _userNameTB(),
                          SizedBox(height: 25.0),
                          _emailTB(),
                          SizedBox(height: 25.0),
                          _passwordTB(false),
                          SizedBox(height: 25.0),
                          _passwordTB(true),
                          Button(
                            // onPressed: submitForm,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPageTwo()),
                              );
                            },
                            child: Text(
                              'Submit',
                              style: kLabelStyle,
                            ),
                          ),
                          _switchToSignIn(),
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

class RegisterPageTwo extends StatefulWidget {
  @override
  _RegisterPageTwoState createState() => _RegisterPageTwoState();
}

class _RegisterPageTwoState extends State<RegisterPageTwo> {
  var tags = [
    'cats',
    'cars',
    'some other thing',
    'sports',
  ];

  var btags = {};

  @override
  void initState() {
    super.initState();
    tags.forEach((m) => btags[m] = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: kBoxGradient,
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 300),
                  Container(
                    child: Text('Select some things that interest you',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ],
              ),
              Container(
                height: 150.0,
                child: Wrap(
                  children: <Widget>[
                    for (var val in tags) ...[
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: FilterChip(
                          label: Text(val),
                          labelStyle: TextStyle(
                            color: btags[val] ? Colors.black : Colors.white,
                          ),
                          selectedColor: Theme.of(context).accentColor,
                          checkmarkColor: Colors.black,
                          selected: btags[val],
                          onSelected: (bool select) {
                            setState(() {
                              btags[val] = !btags[val];
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Button(
                child: Text('Finish Registration'),
                width: 200,
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
