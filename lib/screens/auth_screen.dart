import 'package:flutter/material.dart';
import 'package:gingersystem/models/http_exception.dart';
import 'package:gingersystem/providers/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  LogIn,
  SignUp,
}

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.0,
                      right: 20.0,
                      left: 20.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 30.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/rhizome.png',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Redefining Collective Intelligence\nWith Dynamic Forums',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.SignUp;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;

  final _passwordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.LogIn) {
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      String errorMessage = 'Authentication failed\n';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage += 'Email already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage += 'Not a valid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage += 'Password is too weak';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage += 'Email or password incorrect';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could Not Authenticate.\nTry Again Later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An Error Ocurred'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.SignUp
            ? deviceSize.height * 0.45
            : deviceSize.height * 0.35,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !(value.contains('@'))) {
                      return 'Invalid Email';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.headline6,
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.SignUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    style: Theme.of(context).textTheme.headline6,
                    obscureText: true,
                    validator: _authMode == AuthMode.SignUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                        _authMode == AuthMode.LogIn ? 'LOG IN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.LogIn ? 'SIGN UP' : 'LOG IN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).accentColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
