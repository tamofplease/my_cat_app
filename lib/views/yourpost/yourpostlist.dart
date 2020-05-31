import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/views/yourpost/yourpostlist.dart';
import 'package:youtubelikeapp/views/yourpost/yourpostTile.dart';

class yourPostList extends StatefulWidget {
  @override
  _yourPostListState createState() => _yourPostListState();
}

class _yourPostListState extends State<yourPostList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];
    print(posts.length);
    return  ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        print(posts[index].favusers);
        return yourPostTile(post: posts[index]);
      }
    );
  }
}