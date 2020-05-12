import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtubelikeapp/model/user.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference usersCollection = Firestore.instance.collection("users");

  Future updateUserData(String name, String profileMessage) async {
    return await usersCollection.document(uid).setData ({
        'name': name,
        'profile_message': profileMessage,
      });
  }

  List<User_data> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User_data(
        name: doc.data['name'] ?? '',
        profile_message: doc.data['profile_message'] ?? '',
      );
    }).toList();
  }

  Stream<List<User_data>> get userDatawith {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data["name"],
      profile_message: snapshot.data["profile_message"],
    );
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }



}