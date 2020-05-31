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

  Future updatePostData(String title, String image, int like, String uid, List<String> favusers) async {
    try{
      await postsCollection.document("$title").setData({
      'title': title,
      'timestamp': DateTime.now(),
      'image': title,
      'like': like,
      'uid': uid,
      'favusers':favusers,
      });
      await usersCollection.document("$uid/posts/$title").setData({
        'title': title,
        'timestamp': DateTime.now(),
        'image': image,
        'like': like,
        'uid': uid,
        'favusers':favusers,
      });
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future decreseLikeNumber(Post post) async {
    try{
      var tempOutput = new List<String>.from(post.favusers);
      tempOutput.remove(uid);
      await postsCollection.document("${post.title}").setData({
      'title': post.title,
      'timestamp': post.timestamp,
      'image': post.image,
      'like': post.like - 1,
      'uid' : post.uid,
      'favusers':tempOutput,
      });
      await usersCollection.document("$uid/posts/${post.title}").setData({
        'title': post.title,
        'timestamp': post.timestamp,
        'image': post.image,
        'like': post.like - 1,
        'uid' : post.uid,
        'favusers':tempOutput,
      });
      await usersCollection.document("$uid/likes/${post.title}").delete();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }


  Future updateLikeNumber(Post post) async {
    var tempOutput = new List<String>.from(post.favusers);
    tempOutput.add(uid);
    print(tempOutput);
    try{
      await postsCollection.document("${post.title}").setData({
      'title': post.title,
      'timestamp': post.timestamp,
      'image': post.image,
      'like': post.like + 1,
      'uid' : post.uid,
      'favusers': tempOutput,
      });
      await usersCollection.document("$uid/posts/${post.title}").setData({
        'title': post.title,
        'timestamp': post.timestamp,
        'image': post.image,
        'like': post.like + 1,
        'uid' : post.uid,
        'favusers': tempOutput,
      });
      
      await usersCollection.document("$uid/likes/${post.title}").setData({
        'title': post.title,
        'timestamp': post.timestamp,
        'image': post.image,
        'like': post.like + 1,
        'uid' : post.uid,
        'favusers': tempOutput,
      });
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  List<Post> _likePostsFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return Post(
          title: doc.data['title'] ?? "",
          image: doc.data['image'] ?? " ",
          timestamp: doc.data['timestamp'] ?? DateTime.now(),
          like: doc.data['like'] ?? 0,
          uid: doc.data['uid'] ?? "",
          favusers: doc.data['vusers'] ?? [] ,
        );
      }).toList();
    }catch(e) {
      print(e.toString());
    }
  }

  Stream<List<Post>> get likeposts {
    try {
      final CollectionReference likepostsCollection = Firestore.instance.collection("users/$uid/likes");
      return likepostsCollection.snapshots().map(_likePostsFromSnapshot);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  List<Post> _userPostsFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return Post(
          title: doc.data['title'] ?? " ",
          image: doc.data['image'] ?? " ",
          timestamp: doc.data['timestamp'] ?? DateTime.now(),
          like: doc.data['like'] ?? 0,
          uid: doc.data['uid'] ?? "",
          favusers: doc.data['favusers'] ?? [] ,
        );
      }).toList();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Post>> get userposts {
    try{
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
          uid: doc.data["uid"] ?? "",
          favusers: doc.data['favusers'] ?? [] ,
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