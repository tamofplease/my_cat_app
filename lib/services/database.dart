import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/model/user.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference postsCollection = Firestore.instance.collection("posts");

  Future updateUserData(String name, String profileMessage, String imageUrl, bool loading) async {
    return await usersCollection.document(uid).setData ({
        'name': name,
        'profileMessage': profileMessage,
        'imageUrl': imageUrl,
        'loading': loading,
      });
  }

  Future changeState() async {
    return await usersCollection.document(uid).setData ({

    });
  }

  List<User_data> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User_data(
        name: doc.data['name'] ?? '',
        profileMessage: doc.data['profileMessage'] ?? '',
        imageUrl: doc.data['imageUrl'],
        loading: doc.data['loading'],
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
      loading: snapshot.data["loading"],
    );
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future updatePostData(String title, String image) async {
    return await postsCollection.document("post/$uid/$title").setData({
      'title': title,
      'timestamp': DateTime.now(),
      'image': image,
    });
  }

  List<Post> _allPostsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        title: doc.data['title'],
        image: doc.data['inmage'],
        timestamp: doc.data['timestamp'],
      );
    }).toList();
  }

  Stream<List<Post>> get allposts {
    return postsCollection.snapshots().map(_allPostsFromSnapshot);
  }

}