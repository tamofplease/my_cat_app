import 'package:flutter/material.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Container(          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                child: Image.asset("images/Youtube.png"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "New Post",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  )
                ),
              ),
              SizedBox(width: 30),
            ],
          ),
        ),
      ),
      

    );
  }
}