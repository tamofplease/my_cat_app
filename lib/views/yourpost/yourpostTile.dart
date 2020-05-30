import 'package:flutter/material.dart';
import 'package:youtubelikeapp/views/yourpost/youtpost.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/services/image.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:provider/provider.dart';
import '';

class yourPostTile extends StatelessWidget {

  final Post post;

  yourPostTile({this.post});

  Future<List<dynamic>> pickImage(context ,String image,String imageUrl) async {
    List<dynamic> list = [];
    print(imageUrl);
    list.add(await FirebaseStorageService.loadFromStorage(context, "$imageUrl"));
    list.add(await FirebaseStorageService.loadFromStorage(context, "$image"));
    return list;
  }

  Future<void> changeFavorite(uid, post) async {
    await DatabaseService(uid: uid).updateLikeNumber(post);
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

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