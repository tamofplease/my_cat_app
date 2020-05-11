import 'package:flutter/material.dart';
import 'package:youtubelikeapp/home/home.dart';
import 'package:youtubelikeapp/services/auth.dart';
import 'package:youtubelikeapp/shared/loading.dart';

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
    return loading ? Loading : Scaffold (
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
                Icons.cast,
                color: Colors.black,
            ),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(
                Icons.video_call,
                color: Colors.black,
            ),
            onPressed: (){},
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
              child: CircleAvatar(
                backgroundImage: AssetImage("images/flutter.png"),
              ),
            )
          )
        ]
      ),
      
      body: selectedIndex == 0 ? Home_1() : Favorite(),

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
        onPressed: (){print("pressed!");},
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
    );
  }

  Widget Home_1() {
    return ListView.builder(
      itemCount: array.length,
      itemBuilder: (context,int index){
        return Home(index: index);
      }
    );
  }

  Widget Favorite() {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return Favorite();
      }
    );
  }

  
  
  
}


