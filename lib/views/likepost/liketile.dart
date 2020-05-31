import 'package:flutter/material.dart';
import 'package:youtubelikeapp/views/yourpost/youtpost.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/services/image.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:provider/provider.dart';

class LikeTile extends StatefulWidget{
  final Post post;
  LikeTile({this.post});
  @override
  _LikeTileState createState() => _LikeTileState();
}

class _LikeTileState extends State<LikeTile> {

  

  Future<List<dynamic>> pickImage(context ,String image,String imageUrl) async {
    List<dynamic> list = [];
    list.add(await FirebaseStorageService.loadFromStorage(context, "$imageUrl"));
    list.add(await FirebaseStorageService.loadFromStorage(context, "$image"));
    return list;
  }



  Future<void> changeFavorite(uid, post,like) async {
    
    if(like) {
      await DatabaseService(uid: uid).decreseLikeNumber(post);
    }else {
      await DatabaseService(uid: uid).updateLikeNumber(post);
    }
  }

  void changeLike(bool like) {
    setState(() {
      like = !like;
    });
  }

  @override
  Widget build(BuildContext context) {

    final post = widget.post;
    final user = Provider.of<User>(context);
    bool like = true;

    return StreamBuilder<UserData> (
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, userdata){
        if(userdata.hasData) {
          return FutureBuilder(
            future: pickImage(context, post.image, "${post.uid}/profile.jpg"),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Image.network(snapshot.data[1]),
                      onDoubleTap: () {
                        changeFavorite(user.uid, post, like);
                        changeLike(like);
                        
                      }
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage("${snapshot.data[0]}"),
                        radius: 30,
                      ),
                      title: Text(
                        post.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${userdata.data.name}"),
                      trailing: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: like ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                changeFavorite(user.uid, post, like);
                                changeLike(like);
                              } ,
                              ),
                            Text("${post.like}"),
                          ],
                          )
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                );
              }else {
                return Container();
              }
            }
          );
          
        }else{
          return Container();
        }
      }
    );
  }
}