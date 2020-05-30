import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  var timestamp;
  final String image;
  final int like;
  final String uid;
  Post({ this.title, this.timestamp, this.image , this.like , this.uid});
}
