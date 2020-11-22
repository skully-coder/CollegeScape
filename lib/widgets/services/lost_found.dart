import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manipalleaks/main.dart';

class LostAndFound extends StatefulWidget {
  @override
  _LostAndFoundState createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFound> {
  var messages;

  bool recievedMessages;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  var name;

  var email;

  String itemdesc;

  String phone;
  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  var revmessages;
  getMessageList() async {
    await Firestore.instance
        .collection('/services')
        .document('Lost & Found')
        .get()
        .then((value) {
      messages = value.data['messages'];
      // print(messages);
      if (mounted)
        setState(() {
          recievedMessages = true;
          revmessages = reverseMessages();
          // print(revmessages);
        });
    }).catchError((e) => print(e));
    return messages;
  }

  void initState() {
    super.initState();
    getCurrentUserName();
    getMessageList();
  }

  getCurrentUserName() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data['name'];
        email = value.data['email'];
      });
    }).catchError((e) => print(e));
    // print(name);
    // print(email);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        title: Text(
          'Lost & Found',
          style: TextStyle(
            fontSize: 18.0,
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: darktheme ? Colors.transparent : Colors.grey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      minLines: 10,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: darktheme ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
                              width: 3.0,
                            ),
                          ),
                          labelText: 'Item Description',
                          labelStyle: TextStyle(
                              color: darktheme ? Colors.white : Colors.black),
                          contentPadding: EdgeInsets.all(20.0),
                          alignLabelWithHint: true),
                      validator: (val) =>
                          val == null ? 'Please enter item description' : null,
                      onChanged: (val) {
                        setState(() {
                          itemdesc = val;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: darktheme ? Colors.transparent : Colors.grey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: darktheme ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: darktheme ? Colors.grey[800] : Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: darktheme ? Colors.grey[800] : Colors.white,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: darktheme ? Colors.grey[800] : Colors.white,
                            width: 3.0,
                          ),
                        ),
                        hintText: 'Contact Number',
                        hintStyle: TextStyle(
                            color: darktheme ? Colors.white : Colors.grey[600]),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      validator: (val) => (val.length != 10)
                          ? 'Please Enter a Valid Phone Number'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          phone = val;
                        });
                      },
                    ),
                  ),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.teal,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      var text =
                          'Item Description: \n$itemdesc\nEmail: $email\nPhone Number: $phone';
                      revmessages.add('$name \n$text');
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/services')
                          .document('Lost & Found')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        // print('Data Set');
                      }).catchError((e) => print(e));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
