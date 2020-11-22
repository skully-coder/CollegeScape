import 'package:flutter/material.dart';
import 'package:manipalleaks/authentication/auth.dart';
import 'package:manipalleaks/authentication/deleteUser.dart';
import 'package:manipalleaks/authentication/resetPass.dart';
import 'package:manipalleaks/authentication/sign_in.dart';
import 'package:manipalleaks/drawerWidgets/account.dart';
import 'package:manipalleaks/drawerWidgets/updates.dart';
import 'package:manipalleaks/main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Route _createRoute(var routeName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => routeName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: darktheme ? Colors.blueGrey[900] : Colors.purple,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                color: darktheme ? Colors.blueGrey[900] : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  title: Text(
                    'Account',
                    style: TextStyle(
                        color: darktheme ? Colors.white : Colors.black),
                  ),
                  leading: Icon(
                    Icons.account_box,
                    color: darktheme ? Colors.white : Colors.purple,
                  ),
                  onTap: () {
                    Navigator.push(context, _createRoute(Account()));
                  },
                ),
              ),
              Card(
                color: darktheme ? Colors.blueGrey[900] : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  title: Text(
                    'Version History',
                    style: TextStyle(
                        color: darktheme ? Colors.white : Colors.black),
                  ),
                  leading: Icon(
                    Icons.update,
                    color: darktheme ? Colors.white : Colors.purple,
                  ),
                  onTap: () {
                    Navigator.push(context, _createRoute(Updates()));
                  },
                ),
              ),
              Card(
                color: darktheme ? Colors.blueGrey[900] : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  title: Text(
                    'Delete Your Account',
                    style: TextStyle(
                        color: darktheme ? Colors.red[400] : Colors.red),
                  ),
                  leading: Icon(Icons.delete,
                      color: darktheme ? Colors.red[400] : Colors.red),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Do You Want To Delete This Account ?",
                          style: TextStyle(color: Colors.red),
                        ),
                        content: Text(
                            "Deleting this account will result in the deletion of all the data we have stored for your account including saved event data and configuration settings.\nAre you sure you want to continue?"),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.push(context,
                                    _createRoute(ConfirmUserDetails()));
                              },
                              child: Text('YES')),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('NO')),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmUserDetails extends StatefulWidget {
  @override
  _ConfirmUserDetailsState createState() => _ConfirmUserDetailsState();
}

class _ConfirmUserDetailsState extends State<ConfirmUserDetails> {
  Route _createRoute(var routeName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => routeName,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  final AuthService _auth = AuthService();
  bool signinstate = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: (!signinstate)
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: height * 0.15),
                      Text(
                        'Confirm Your Details',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: height * 0.1),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[850],
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        validator: (val) => validateEmail(val),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[850],
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              color: Colors.grey[850],
                              width: 3.0,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        validator: (val) => val.length < 6
                            ? 'password must be more than 6 character'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: height * 0.08),
                      FlatButton(
                        onPressed: () async {
                          print('Deleting User...');

                          if (_formKey.currentState.validate()) {
                            dynamic result =
                                await _auth.signIn(email, password);
                            if (result == "Enter A Valid Email-Id") {
                              setState(() {
                                error = "Enter A Valid Email-Id";
                              });
                            } else if (result == "Incorrect Password") {
                              setState(() {
                                error = "Incorrect Password";
                              });
                            } else if (result == "User Not Found") {
                              setState(() {
                                error = "User Not Found";
                              });
                            } else if (result == "User diasbled") {
                              setState(() {
                                error = "User diasbled";
                              });
                            } else if (result == "Too many requests") {
                              setState(() {
                                error = "Too many requests";
                              });
                            } else if (result == "Unknown error") {
                              setState(() {
                                error = "Unknown error";
                              });
                            } else {
                              setState(() {
                                signinstate = !signinstate;
                              });
                              await AuthDeleteService()
                                  .deleteUser(email, password);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  _createRoute(SignIn()),
                                  (Route<dynamic> route) => false);
                            }
                          }
                        },
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordPage()));
                        },
                        padding: EdgeInsets.all(0.0),
                        child: Center(
                          child: Text('Forgot password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                //decoration: TextDecoration.underline,
                              )),
                        ),
                      ),
                      SizedBox(height: 85.0),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                Text(
                  'Deleting Account...',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
    );
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }
}
