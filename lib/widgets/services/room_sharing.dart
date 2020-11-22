import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manipalleaks/main.dart';

class RoomSharing extends StatefulWidget {
  final String id = "Room Sharing";
  @override
  _RoomSharingState createState() => _RoomSharingState();
}

class _RoomSharingState extends State<RoomSharing>
    with AutomaticKeepAliveClientMixin {
  String name;
  String email;
  String branchName;
  String cgpa;
  String pcgpa;
  String phone;
  var fhostelblocks = [
    'Select Hostel',
    'Block 3',
    'Block 4',
    'Block 7',
    'Block 12',
    'Block 13'
  ];
  var mhostelblocks = [
    'Select Hostel',
    'Block 8',
    'Block 9',
    'Block 10',
    'Block 14',
    'Block 15'
  ];
  var selectedHostel = 'Select Hostel';
  String selectedGender = 'Gender';
  var timeofday = ["A.M", "P.M"];
  var selectedTimeofday = "A.M";
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  var messages;

  String otherprefs;
  @override
  bool get wantKeepAlive => true;
  bool recievedMessages;
  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  var revmessages;
  getMessageList() async {
    await Firestore.instance
        .collection('/services')
        .document('Room Sharing')
        .collection('$selectedGender')
        .document('messages')
        .get()
        .then((value) {
      messages = value.data['messages'];
      print(messages);
      if (mounted)
        setState(() {
          recievedMessages = true;
          revmessages = reverseMessages();
          print(revmessages);
        });
    }).catchError((e) => print(e));
    return messages;
  }

  void initState() {
    super.initState();
    getCurrentUserName().whenComplete(() => getMessageList());
  }

  Future getCurrentUserName() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data['name'];
        email = value.data['email'];
        branchName = value.data['branch'];
        selectedGender = value.data['gender'];
      });
    }).catchError((e) => print(e));
    print(name);
    print(email);
    print(branchName);
    print(selectedGender);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        title: Text(
          'Room Sharing',
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                        hintText: 'CGPA',
                        hintStyle: TextStyle(
                            color: darktheme ? Colors.white : Colors.grey[600]),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      validator: (val) =>
                          (double.parse(val) < 0.00 || double.parse(val) > 10)
                              ? 'CGPA should be between 0 and 10'
                              : null,
                      onChanged: (val) {
                        setState(() {
                          cgpa = val;
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
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                        hintText: 'Preffered CGPA',
                        hintStyle: TextStyle(
                            color: darktheme ? Colors.white : Colors.grey[600]),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      validator: (val) =>
                          (double.parse(val) < 0.00 || double.parse(val) > 10)
                              ? 'CGPA should be between 0 and 10'
                              : null,
                      onChanged: (val) {
                        setState(() {
                          pcgpa = val;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 500.0,
                    padding: EdgeInsets.fromLTRB(16.0, 2.0, 0.0, 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: darktheme ? Colors.grey[800] : Colors.white,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: darktheme ? Colors.transparent : Colors.grey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: DropdownButton(
                      underline: Divider(
                        thickness: 0.0,
                        color: darktheme ? Colors.grey[800] : Colors.white,
                      ),
                      isExpanded: false,
                      items: (selectedGender == 'Male')
                          ? mhostelblocks.map((value) {
                              return DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  value: value);
                            }).toList()
                          : fhostelblocks.map((value) {
                              return DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  value: value);
                            }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedHostel = val;
                        });
                        print(selectedHostel);
                      },
                      value: selectedHostel,
                      style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black,
                          fontSize: 20.0),
                      dropdownColor:
                          darktheme ? Colors.grey[800] : Colors.white,
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
                      keyboardType: TextInputType.phone,
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
                      textAlignVertical: TextAlignVertical.top,
                      minLines: 3,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
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
                        alignLabelWithHint: true,
                        hintText: 'Other Preferences',
                        hintStyle: TextStyle(
                            color: darktheme ? Colors.white : Colors.grey[600]),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      onChanged: (val) {
                        setState(() {
                          otherprefs = val;
                        });
                      },
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.teal,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      print(revmessages);
                      print(cgpa);
                      print(pcgpa);
                      print(selectedHostel);
                      if (otherprefs == null) otherprefs = 'None';
                      var text =
                          'Branch: $branchName\nCGPA: $cgpa\nPreferred CGPA: $pcgpa\nPreferred Hostel Block: $selectedHostel\nOther Preferences: $otherprefs\nEmail: $email\nPhone Number: $phone';
                      if (revmessages == null) {
                        revmessages = ['$name \n$text'];
                      } else {
                        revmessages.add('$name \n$text');
                      }
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/services')
                          .document('Room Sharing')
                          .collection('$selectedGender')
                          .document('messages')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        print('Data Set');
                      }).catchError((e) => print(e));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'POST',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
