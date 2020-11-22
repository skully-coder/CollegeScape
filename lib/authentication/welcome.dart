import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manipalleaks/widgets/homepage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.3,
                ),
                Text(
                  'Welcome\nto\nCollegeScape!',
                  style: TextStyle(
                    fontSize: height * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: height * 0.3,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdditionalDetails('', '')));
                  },
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.teal,
                  shape: StadiumBorder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdditionalDetails extends StatefulWidget {
  final String section;
  final String regNo;
  AdditionalDetails(this.section, this.regNo);
  @override
  _AdditionalDetailsState createState() =>
      _AdditionalDetailsState(section, regNo);
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _years = ['First Year', 'Second Year', 'Third Year', 'Fourth Year'];
  var secondBranches = [
    "AERO: Aeronautical Engineering",
    "AUTO: Automobile Engineering",
    "BME: Biomedical Engineering",
    "BIO: Biotechnology",
    "CHE: Chemical Engineering",
    "CIV: Civil Engineering",
    "CCE: Computer & Communication Engineering",
    "CSE: Computer Science & Engineering",
    "ELE: Electrical & Electronics Engineering",
    "ECE: Electronics & Communication Engineering",
    "IP: Industrial & Production Engineering",
    "IT: Information Technology",
    "EIE: Electronics and Instrumentation Engineering",
    "MME: Mechanical Engineering",
    "MTE: Mechatronics",
    "MED: Media Technology",
  ];
  var _selectedBranch = 'AERO: Aeronautical Engineering';
  var _selectedYear = 'First Year';
  var section;
  var regNo;
  var genders = ['Male', 'Female'];
  var selectedgender = 'Male';

  var initialEvents = {
    '${DateTime.utc(2020, 4, 10, 12)}': [
      'Good Friday\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 5, 1, 12)}': [
      'Labour Day\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 5, 25, 12)}': [
      'Ramzan\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 8, 22, 12)}': [
      'Ganesh Chaturthi\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 9, 11, 12)}': [
      'Janmashtami\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 10, 2, 12)}': [
      'Gandhi Jayanti\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 10, 26, 12)}': [
      'Vijaya Dashami\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 11, 14, 12)}': [
      'Diwali\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 12, 25, 12)}': [
      'Christmas\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 1, 26, 12)}': [
      'Republic Day\r12:00 A.M\rNo Details Available'
    ],
    '${DateTime.utc(2020, 8, 15, 12)}': [
      'Independence Day\r12:00 A.M\rNo Details Available'
    ],
  };
  _AdditionalDetailsState(this.section, this.regNo);
  getCurrentUserName() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        selectedgender = value.data['gender'];
        if (selectedgender == null) selectedgender = 'Male';
        _selectedYear = value.data['year'];
        if (_selectedYear == null) _selectedYear = 'First Year';
        section = value.data['section'];
        regNo = value.data['reg_no'];
        _selectedBranch = value.data['branch'];
        if (_selectedBranch == null)
          _selectedBranch = 'AERO: Aeronautical Engineering';
      });
    }).catchError((e) => print(e));
    print(selectedgender);
    print(_selectedYear);
    print(section);
    print(regNo);
    print(_selectedBranch);
    // print(uname);
    // print(isUserDetailsLoaded);
  }

  Iterable<String> hintsection = ['Hello'];

  void initState() {
    super.initState();
    getCurrentUserName();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: height * 0.01),
                  Text(
                    'Enter a few additional details',
                    style: TextStyle(
                      fontSize: height * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[850], width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[850]),
                    child: DropdownButton<String>(
                      underline: Divider(color: Colors.grey[850]),
                      hint: Text("Enter Gender"),
                      items:
                          genders.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedgender = val;
                        });
                        print(selectedgender);
                      },
                      value: selectedgender,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      dropdownColor: Colors.grey[850],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[850], width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[850]),
                    child: DropdownButton<String>(
                      underline: Divider(color: Colors.grey[850]),
                      hint: Text("Enter Year"),
                      items:
                          _years.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedYear = val;
                        });
                        print(_selectedYear);
                      },
                      value: _selectedYear,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      dropdownColor: Colors.grey[850],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: '$section',
                    autofillHints: hintsection,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                          width: 3.0,
                        ),
                      ),
                      labelText: 'Section',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.all(20.0),
                      // hintText: section,
                      // hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (val) =>
                        val.length != 1 || val.contains(new RegExp('r[0-9]'))
                            ? 'Section should be a single character'
                            : null,
                    obscureText: false,
                    onChanged: (val) {
                      setState(() {
                        section = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: regNo,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                          width: 3.0,
                        ),
                      ),
                      labelText: 'Registration Number',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.all(20.0),
                      // hintText: regNo,
                      // hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (val) => val.length != 9
                        ? 'Registration Number should contain 9 digits'
                        : null,
                    obscureText: false,
                    onChanged: (val) {
                      setState(() {
                        regNo = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[850], width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[850],
                    ),
                    child: DropdownButton(
                      underline: Divider(color: Colors.grey[850]),
                      isExpanded: false,
                      items: secondBranches.map((value) {
                        return DropdownMenuItem(
                            child: Text(
                              value,
                              style: TextStyle(fontSize: height * 0.0148),
                            ),
                            value: value);
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedBranch = val;
                        });
                        print(_selectedBranch);
                      },
                      value: _selectedBranch,
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      dropdownColor: Colors.grey[850],
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final FirebaseUser user = await auth.currentUser();
                        await Firestore.instance
                            .collection('/users')
                            .document(user.uid)
                            .setData({
                              'year': _selectedYear,
                              'section': section,
                              'reg_no': regNo,
                              'branch': _selectedBranch,
                              'gender': selectedgender,
                              'events': initialEvents,
                            }, merge: true)
                            .then((value) => print('Additional info Set'))
                            .catchError((e) => print(e));
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    },
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.teal,
                    shape: StadiumBorder(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // addTimetable(var year, var branch, var section) {
  //   List daysinmonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  //   var day = 5;
  //   for(var month = 9 ; month < 12; month++){
  //     for(var date = 1; date < daysinmonth[month];date++){
  //       if(day == 0){
  //         if(initialEvents[DateTime.utc(2020, month, date, 12)] == null){

  //         }
  //       }
  //     }
  //   }
  // }
}
