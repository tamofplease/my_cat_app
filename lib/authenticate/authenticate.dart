import 'package:flutter/material.dart';
import 'package:youtubelikeapp/authenticate/register.dart';
import 'package:youtubelikeapp/authenticate/sign_in.dart';



class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool _showSignIn = true;

  void toggleState() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSignIn ? SignIn(toggleView: toggleState) : Register(toggleView: toggleState);
  }
}