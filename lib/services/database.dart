import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/model/user.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference postsCollection = Firestore.instance.collection("posts");

  Future updateUserData(String name, String profileMessage, String imageUrl) async {
    print("%%%%%%%%%%%%%%%%%%%update%%%%%%%%%%%%%%%%%%%%%%%");
    return await usersCollection.document(uid).setData ({
        'name': name,
        'profileMessage': profileMessage,
        'imageUrl': imageUrl,
      });
  }

  List<User_data> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User_data(
        name: doc.data['name'] ?? '',
        profileMessage: doc.data['profileMessage'] ?? '',
        imageUrl: doc.data['imageUrl']
      );
    }).toList();
  }

  Stream<List<User_data>> get allUserData {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data["name"],
      profileMessage: snapshot.data["profileMessage"],
      imageUrl: snapshot.data["imageUrl"],
    );
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future updatePostData(String title, int good) async {
    return await postsCollection.document(uid).setData({
      'title': title,
      'timestamp': DateTime.now(),
      'good': good,
    });
  }

  List<Post> _allPostsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        title: doc.data['title'],
        good: doc.data['good'],
        timestamp: doc.data['timestamp'],
      );
    }).toList();
  }

  Stream<List<Post>> get allposts {
    return postsCollection.snapshots().map(_allPostsFromSnapshot);
  }

}