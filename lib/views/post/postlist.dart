import 'package:flutter/material.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/views/post/posttile.dart';

class postList extends StatefulWidget {
  @override
  _postListState createState() => _postListState();
}

class _postListState extends State<postList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return postTile(post: posts[index]);
      }
    );
  }
}