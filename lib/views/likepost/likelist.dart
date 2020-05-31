import 'package:flutter/material.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/views/likepost/liketile.dart';

class likeList extends StatefulWidget {
  @override
  _likeListState createState() => _likeListState();
}

class _likeListState extends State<likeList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];
    
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return LikeTile(post: posts[index]);
      }
    );
  }
}