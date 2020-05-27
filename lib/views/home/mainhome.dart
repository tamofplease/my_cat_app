import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/views/post/postlist.dart';
import 'package:youtubelikeapp/views/post/new.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/views/home/setting_form.dart';
import 'package:youtubelikeapp/views/home/home.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/image.dart';
import 'package:youtubelikeapp/services/auth.dart';
import 'package:youtubelikeapp/shared/loading.dart';
import 'package:youtubelikeapp/model/post.dart';

class Main extends StatefulWidget {
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  final AuthServices _auth = AuthServices();
  bool loading = false;

  var array = new List.generate(5, (i)=> false);
  List<Widget> favorites = <Widget>[
    
  ];
  static int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void setindex(int index){
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);    

    void _getEditForm()  {
      showDialog<void>(context: context, builder: (context) {
        return AlertDialog(
          content: Container(
            height: 200,
            padding: EdgeInsets.all(0),
            child: SettingForm(),
          ),
        );
      });
    }

    Widget _buildFutureBuilder(UserData user) {
      return FutureBuilder(
        future: FirebaseStorageService.loadFromStorage(context, user.imageUrl),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(snapshot.data),
            );
          }
          return CircularProgressIndicator();
        }
      );
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData && !snapshot.data.loading) {
          UserData userData = snapshot.data;
          return Scaffold (  
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Container(
                width: 300,
                height: 500,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset("images/Youtube.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "マロン",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: false,
              actions: <Widget> [
                IconButton(
                  icon: Icon(
                      Icons.brightness_5,
                      color: Colors.black,
                  ),
                  onPressed: (){
                    _getEditForm();
                  },
                ),
                IconButton(
                  icon: Icon(
                      Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: (){},
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap:  ()  async {
                      loading = true;
                      await _auth.signOut();
                      loading = false;
                    },
                    child: _buildFutureBuilder(userData),
                  )
                )
              ]
            ),
            
            body: StreamProvider<List<Post>>.value (
              value: DatabaseService(uid: user.uid).allposts,
              child: Container(
                child: postList(),
              ),
            ),

            bottomNavigationBar: BottomNavigationBar(
              onTap: setindex,
              currentIndex: selectedIndex,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.red,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  title: Text("Home"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text("like"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up),
                  title: Text("Trending"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.subscriptions),
                  title: Text("Trending"),
                ),
              ]
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPost(),
                  )
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.grey,
            ),
          );
        }else {
          return Loading();
        }
      }
    );  
  }
}


