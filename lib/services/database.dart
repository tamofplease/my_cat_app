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

  Future updatePostData(String title, String image, int like) async {
    await postsCollection.document("$title").setData({
      'title': title,
      'timestamp': DateTime.now(),
      'image': image,
      'like': like,
    });
    await usersCollection.document("$uid/posts/$title").setData({
      'title': title,
      'timestamp': DateTime.now(),
      'image': image,
      'like': like,
    });
  }


  Future updateLikeNumber(Post post) async {
    await postsCollection.document("${post.title}").setData({
      'title': post.title,
      'timestamp': post.timestamp,
      'image': post.image,
      'like': post.like + 1,
    });
    await postsCollection.document("$uid/posts/${post.title}").setData({
      'title': post.title,
      'timestamp': post.timestamp,
      'image': post.image,
      'like': post.like + 1,
    });
  }

  List<Post> _userPostsFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return Post(
          title: doc.data['title'] ?? " ",
          image: doc.data['image'] ?? " ",
          timestamp: doc.data['timestamp'] ?? DateTime.now(),
          like: doc.data['like'] ?? 0,
        );
      }).toList();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Post>> get userposts {
    try{
      print("something");
      final CollectionReference userpostsCollection = Firestore.instance.collection("users/${uid}/posts");
      return userpostsCollection.snapshots().map(_userPostsFromSnapshot);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  List<Post> _allPostsFromSnapshot(QuerySnapshot snapshot) {
    
    try{
      return snapshot.documents.map((doc) {
        return Post(
          title: doc.data['title'] ?? " ",
          image: doc.data['image'] ?? " ",
          timestamp: doc.data['timestamp'] ?? DateTime.now(),
          like: doc.data['like'] ?? 0,
        );
      }).toList();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Post>> get allposts {  
    try {
      return postsCollection.snapshots().map(_allPostsFromSnapshot);
    }catch(e) {
      print(e.toString());
      return null;
    }
    
  }

}