import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtubelikeapp/model/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference postCollection = Firestore.instance.collection("users");

  Future updateUserData(String name, String profileMessage) async {
    return await postCollection.document(uid).setData ({
        'name': name,
        'profile_message': profileMessage,
      });
  }


}