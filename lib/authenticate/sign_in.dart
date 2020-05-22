import 'package:flutter/material.dart';
import 'package:youtubelikeapp/services/auth.dart';
import 'package:youtubelikeapp/shared/constans.dart';
import 'package:youtubelikeapp/shared/loading.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool loading = false;
  final AuthServices auth = AuthServices();
  String email = "";
  String password = "";
  String error = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    void _showSignInDialog() {

      showDialog<void> (
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            titlePadding: EdgeInsets.all(20.0),
            title: Text("Sign In Form"),
            content: Container(              
              height: 200,
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
                        decoration: textInputDecoration.copyWith(hintText: "email"),
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
                        child: Text("SignIn"),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            Navigator.of(context).pop();
                            dynamic result = await auth.signInWithEmailAndPassword(email, password);
                            if(result == null) {
                              setState(() {
                                loading =false;
                                error = 'please supply a valid email';
                              });
                              _showSignInDialog();
                              print(error.toString());
                            }
                          }
                        }
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(height: 20),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(height: 20),
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
        backgroundColor: Colors.pinkAccent,
        title: Text('Sign in'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Register",
            icon: Icon(
                Icons.people,
                color: Colors.black,
            ),
            onPressed: widget.toggleView,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/neko_3.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: RaisedButton(
            child: Text("Sign In"),
            onPressed: () => _showSignInDialog(),
          ),
        ),
      ),
    );
  }
}