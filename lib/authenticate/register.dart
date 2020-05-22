import 'package:flutter/material.dart';
import 'package:youtubelikeapp/services/auth.dart';
import 'package:youtubelikeapp/shared/constans.dart';
import 'package:youtubelikeapp/shared/loading.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  void initState() {
    super.initState();
  }

  final AuthServices auth = AuthServices();

  bool loading = false;
  String email = "";
  String password = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    void _showRegisterDialog() {
      showDialog<void> (
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Register Form"),
            content: Container(
              height: 150,
              
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: textInputDecoration.copyWith(hintText: "Email"),
                        validator: (val) => val.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val); 
                        },
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: TextFormField(
                        showCursor: true,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: textInputDecoration.copyWith(hintText: "Password"),
                        obscureText: true,
                        validator: (val) => val.length < 6 ? "Enter a password more than 6 length" : null,
                        onChanged: (val) {
                          setState(() => password = val); 
                        },
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: RaisedButton(
                        color: Colors.grey,
                        child: Text("register"),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            Navigator.of(context).pop();
                            setState(() => loading = true);
                            dynamic result = await auth.registerWithEmailAndPassword(email, password);
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'please supply a valid email';
                              });
                            }
                            
                          }
                        }
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // actions: <Widget>[
            //   FlatButton(
            //     child: const Icon(Icons.multiline_chart),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     }
            //   )
            // ],
          );
        }
      );
    }
    

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Sign in",
            icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.black,
            ),
            onPressed: widget.toggleView,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/neko_2.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: RaisedButton(
            child: Text("Register!"),
            onPressed: () => _showRegisterDialog(),
          ),
        ),
      ),
    );
  }
}
