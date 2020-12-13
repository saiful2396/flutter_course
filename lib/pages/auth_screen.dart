import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scope-models/main_model.dart';
import '../models/auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/product');
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (val) {
                        if (val.isEmpty ||
                            !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(val)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['email'] = value;
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _passwordController,
                      validator: (val) {
                        if (val.isEmpty || val.length < 6) {
                          return 'Please enter at least 6 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['password'] = value;
                      },
                    ),
                    SizedBox(height: 10.0),
                    _authMode == AuthMode.SignUp
                        ? TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (val) {
                              if (_passwordController.text != val) {
                                return 'Password do not match';
                              }
                              return null;
                            },
                          )
                        : Container(),
                    SwitchListTile(
                      value: _formData['acceptTerms'],
                      title: Text('Accept Terms'),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) {
                        setState(() {
                          _formData['acceptTerms'] = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    FlatButton(
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'SignUp' : 'Login'}'),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.SignUp
                              : AuthMode.Login;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant<MainModel>(
                        builder: (context, child, model) {
                      return model.isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : RaisedButton(
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGNUP',
                                textScaleFactor: 1.3,
                              ),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () => _submitForm(model.authenticate),
                            );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
