import 'package:flutter/material.dart';
import 'package:youtubelikeapp/shared/constans.dart';

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final _formKey = GlobalKey<FormState>();
  String _title = "";
  var _postImage = "";

  Widget Box() {
    return Container(
      padding: EdgeInsets.all(50),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey
      ),
      child: GestureDetector(
        child: Icon(
          Icons.add,
          size: 100,
        ),
      ),
    );
  }

  Widget TitleStyle() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.bottom,
      decoration: textInputDecoration.copyWith(hintText: "title"),
      validator: (val) => val.isEmpty? "Enter the title" : null,
      onChanged: (val) {
        setState(() => _title = val);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _postImage.isEmpty? Box() : Box(),
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TitleStyle(),
            ),
            RaisedButton(
              color: Colors.grey,
              child: Text('Post!', style: TextStyle(color: Colors.white)),
              onPressed: (){
                print("save!");
                Navigator.pop(context);
              }
            ),
          ],
        )
      )
    );
  }
}