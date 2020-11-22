import 'package:flutter/material.dart';
import 'package:manipalleaks/authentication/auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  AuthService _auth = AuthService();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 170.0),
                Text(
                  'Reset    Password',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 100.0),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[850], 
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.grey[850],
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.grey[850],
                        width: 3.0,
                      ),
                    ),
                    labelText: 'Enter Email',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                  validator: (value) {
                    setState(() {
                      email = value;
                    });
                    return validateEmail(value);
                  },
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[850], 
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.grey[850],
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.grey[850],
                        width: 3.0,
                      ),
                    ),
                    labelText: 'Confirm Email',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                  validator: (value) {
                    if (value != email) {
                      return 'Emails do not match';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 25.0),
                FlatButton(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await _auth.resetPassword(email);
                      Navigator.pop(context);
                    }
                  },
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Send Reset Password Link',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                ),
              ]),
        ),
      ),
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

// Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Password'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0)),
//                       hintText: 'Enter Email'),
//                   validator: (value) {
//                     setState(() {
//                       email = value;
//                     });
//                     return validateEmail(value);
//                   },
//                 ),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0)),
//                       hintText: 'Confirm Email'),
//                   validator: (value) {
//                     if (value != email) {
//                       return 'Emails do not match';
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),
//                 SizedBox(
//                   height: 50.0,
//                 ),
//                 RaisedButton(
//                   onPressed: () async {
//                     if (_formkey.currentState.validate()) {
//                       await _auth.resetPassword(email);
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text(
//                     'Send Reset Password Link',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   color: Colors.purple,
//                   splashColor: Colors.purple,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }