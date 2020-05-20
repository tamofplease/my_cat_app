import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/shared/constans.dart';
import 'package:youtubelikeapp/shared/loading.dart';
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
  var _currentUserImage;

  Future _getImage() async {
      var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _currentUserImage = tempImage;
      });
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
                  Row(
                    children: <Widget>[
                      // CircleAvatar(backgroundColor: ,)
                      Text('Update your profile'),
                    ],
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
                      onChanged: (val) => setState(() => _currentprofile = val),
                    ),
                  ),

                  Expanded(flex: 1, child: SizedBox(height:20)),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      child: Text("Select Image"),
                      onPressed: () => _getImage(),
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
                        final StorageUploadTask task = firebasestorageRef.putFile(_currentUserImage);
                        print("≠≠≠≠≠≠≠≠≠≠≠≠$task ~~~~~~~~~~~~~~~");
                        if(_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentName ?? userData.name,
                            _currentprofile ?? userData.profileMessage,
                            _currentUserImage ?? userData.imageUrl,
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