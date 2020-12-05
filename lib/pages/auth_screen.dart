import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  void _submitForm() {
    print(_emailValue);
    print(_passwordValue);
    Navigator.pushReplacementNamed(
      context,
      '/product',
    );
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _emailValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (String value) {
                      _passwordValue = value;
                    },
                  ),
                  SwitchListTile(
                    value: _acceptTerms,
                    title: Text('Accept Terms'),
                    activeColor: Theme.of(context).primaryColor,
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
