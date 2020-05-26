import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youtubelikeapp/shared/constans.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:youtubelikeapp/model/post.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/database.dart';

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final _formKey = GlobalKey<FormState>();
  String _title = "";
  var _postImage;

  bool _disable = false;

  Future _getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _postImage = tempImage;
    });
  }

  Widget imageBox() {
    return Container(
      padding: EdgeInsets.all(50),
      margin: EdgeInsets.all(20),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: new FileImage(_postImage),
        )
      )
    );
  }

  Widget box() {
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
        onTap: () {
          _getImage();
        }, 
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

  void toggleButtonState() {
    setState(() {
      _disable = !_disable;
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return SingleChildScrollView(
      reverse: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _postImage != null ? imageBox() : box(),
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TitleStyle(),
            ),
            RaisedButton(
              color: Colors.grey,
              child: _disable? Text('posting...', style: TextStyle(color: Colors.white)) : Text('Post', style: TextStyle(color: Colors.white)),
              onPressed: _disable ? null : () async {
                toggleButtonState();
                String path = '${user.uid}/posts/$_title';

                final StorageReference  firebasesotrageRef = FirebaseStorage.instance.ref().child(path);
                if(_postImage != null) {
                  final StorageUploadTask task = firebasesotrageRef.putFile(_postImage);
                  StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
                }

                if(_formKey.currentState.validate()){
                  await DatabaseService(uid: user.uid).updatePostData(
                    _title,
                    path,
                  );
                  toggleButtonState();
                  Navigator.pop(context);
                }                
              },
            ),
          ],
        )
      )
    );
  }
}