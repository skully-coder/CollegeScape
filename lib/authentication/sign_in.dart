import 'package:flutter/material.dart';
import 'package:manipalleaks/widgets/homepage.dart';
import 'package:manipalleaks/authentication/register.dart';
import 'package:manipalleaks/authentication/auth.dart';
import 'package:manipalleaks/authentication/resetPass.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool signinstate = false;
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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                      SizedBox(height: height * 0.2),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: height * 0.10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                      SizedBox(height: height * 0.015),
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
                              color: Colors.red,
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
                      //SizedBox(height: height * 0.0),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      FlatButton(
                          onPressed: () async {
                            print('Signing in...');

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
                                Navigator.of(context)
                                    .pushReplacement(_createRoute(HomePage()));
                              }
                            }
                          },
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          color: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0))),
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
                                color: Colors.teal[300],
                                //fontWeight: FontWeight.bold,
                                //decoration: TextDecoration.underline,
                              )),
                        ),
                      ),
                      SizedBox(height: height * 0.125),
                      Center(
                        child: Text("Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              //fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(height: height * 0.016),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            _createRoute(Register()),
                          );
                        },
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          // side: BorderSide(
                          //   color: Colors.grey[800],
                          //   width: 3.0,
                          // ),
                        ),
                      ),
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
                  'Signing In...',
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
