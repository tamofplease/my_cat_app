import 'package:flutter/material.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:youtubelikeapp/shared/constans.dart';
import 'package:youtubelikeapp/shared/loading.dart';
import 'package:provider/provider.dart';


class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {

  final _formKey = GlobalKey<FormState>();
  
  String _currentName;
  String _currentprofile;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData> (
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Update your setting'),
                SizedBox(height: 20),
                Flexible(
                  flex: 2,
                  child: TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                  ),
                ),
                Flexible(flex: 1,child: SizedBox(height: 30)),
                Flexible(
                  flex: 2,
                  child: TextFormField(
                    initialValue: userData.profile_message,
                    decoration: textInputDecoration,
                    onChanged: (val) => setState(() => _currentprofile = val),
                  ),
                ),
                Flexible(flex: 1, child: SizedBox(height:20)),
                Flexible(
                  flex: 2,
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentName ?? userData.name,
                          _currentprofile ?? userData.profile_message,
                        );
                        Navigator.pop(context);
                      }
                    }
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }
}