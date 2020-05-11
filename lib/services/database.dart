import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtubelikeapp/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({ this.uid });

  final CollectionReference postReference = Firestore.instance.collection("posts");

  Future updateUserData(String name, String )


}