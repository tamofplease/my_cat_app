import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/services/image.dart';
import 'package:youtubelikeapp/shared/constans.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';


class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {

  final _formKey = GlobalKey<FormState>();

  
  String _currentName;
  String _currentprofile;
  var _currentUserImage ;

  Future _getImage() async {
      var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _currentUserImage = tempImage;
      });
  }

  Widget _buildFuture(UserData user) {
    return FutureBuilder(
      future: FirebaseStorageService.loadFromStorage(context, user.imageUrl),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(snapshot.data),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData> (
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          return Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                 
                  GestureDetector(
                    child: _buildFuture(userData),
                    onTap: () => _getImage(),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: userData.name,
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty ? 'please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                  ),
                  Expanded(flex: 1,child: SizedBox(height: 30)),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: userData.profileMessage,
                      decoration: textInputDecoration,
                      // decoration: textInputDecoration.copyWith(fillColor: Colors.black),
                      onChanged: (val) => setState(() => _currentprofile = val),
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox(height:20)),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      color: Colors.black,
                      child: Text(
                        'update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        final StorageReference firebasestorageRef = FirebaseStorage.instance.ref().child('${userData.uid}').child("profile.jpg");
                        if(_currentUserImage != null) {
                          final StorageUploadTask task = firebasestorageRef.putFile(_currentUserImage);
                        }
                        
                        if(_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentName ?? userData.name,
                            _currentprofile ?? userData.profileMessage,
                            userData.imageUrl == "default.png"  && _currentUserImage == null ?  "default.png" : "${userData.uid}/profile.jpg" ,
                          );
                          Navigator.pop(context);
                        }
                      }
                    ),
                  ), 
                ],
              ),
            ),
          );
        }else {
          return CircularProgressIndicator();
        }
        
      }
    );
  }
}