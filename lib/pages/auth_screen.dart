import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'E-mail'),
            onChanged: (String value) {
              setState(() {
                _emailValue = value;
              });
            },
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
            onChanged: (String value) {
              _passwordValue = value;
            },
          ),
          SwitchListTile(
            value: _acceptTerms,
            title: Text('Accept Terms'),
            activeColor: Theme
                .of(context)
                .primaryColor,
            onChanged: (bool value) {
              setState(() {
                _acceptTerms = value;
              });
            },
          ),
          RaisedButton(
            child: Text(
              'Login',
              textScaleFactor: 1.3,
            ),
            textColor: Colors.white,
            color: Theme
                .of(context)
                .primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}
