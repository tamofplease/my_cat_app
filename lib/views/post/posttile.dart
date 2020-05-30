import 'package:flutter/material.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/services/image.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/shared/loading.dart';



class postTile extends StatelessWidget {

  final Post post;

  postTile({ this.post });

  Future<List<dynamic>> pickImage (context, image, uid) async{
    List<dynamic> list = [];
    
    list.add(await FirebaseStorageService.loadFromStorage(context, "$uid/profile.jpg"));
    list.add(await FirebaseStorageService.loadFromStorage(context, image));
    return list;
  }

  Future<void> changeFavorite(uid, post) async {
    await DatabaseService(uid: uid).updateLikeNumber(post);
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    return FutureBuilder (
      future: pickImage(context, post.image, post.uid),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return StreamBuilder<UserData>(
            stream: DatabaseService(uid: post.uid).userData,
            builder: (context, userdata){
              if(userdata.hasData) {
                return Column (
                  children: <Widget>[
                    GestureDetector(
                      child: Image.network(snapshot.data[1]),
                      onDoubleTap: () {
                        changeFavorite(user.uid, post);
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
                              icon: Icon(Icons.favorite),
                              onPressed: () => changeFavorite(user.uid, post),
                              ),
                            Text("${post.like}"),
                          ],
                          )
                      )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }else {
                return Container();
              }
              
            }
          );
        }else {
          return CircularProgressIndicator();
        }
        
      }
      
    );
  }
}