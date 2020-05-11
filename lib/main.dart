import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/auth.dart';
import 'package:youtubelikeapp/views/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value (
      value: AuthServices().user,
      child: MaterialApp(
        home: Wrapper(),
      )
    );
  }
}

