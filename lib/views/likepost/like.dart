import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/views/yourpost/yourpostlist.dart';
import 'package:youtubelikeapp/views/likepost/likelist.dart';

class LikePost extends StatefulWidget {
  @override
  LikePostState createState() => LikePostState();
}

class LikePostState extends State<LikePost> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamProvider<List<Post>>.value(
      value: DatabaseService(uid: user.uid).likeposts,
      child: likeList(),
    );
  }
}