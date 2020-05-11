import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/authenticate/authenticate.dart';
import 'package:youtubelikeapp/home/mainhome.dart';
import 'package:youtubelikeapp/model/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    if(user == null) {
      return Authentication();
    }else {
      return Main();
    }
  }
}