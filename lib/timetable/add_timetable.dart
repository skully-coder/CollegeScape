import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manipalleaks/main.dart';

class AddTimeTable extends StatefulWidget {
  @override
  _AddTimeTableState createState() => _AddTimeTableState();
}

class _AddTimeTableState extends State<AddTimeTable> {
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
  List days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  bool mondaymore = false;

  List mondays;

  String monday;

  bool isFirstYearSelected;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        elevation: 0,
        title: Text('Add Timetable',
            style: GoogleFonts.montserrat(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: darktheme ? Colors.grey[100] : Colors.grey[900])),
      ),
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[50],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                      color: darktheme ? Colors.grey[850] : Colors.grey[50]),
                  child: DropdownButton<String>(
                    underline: Divider(color: Colors.transparent),
                    hint: Text("Enter Year"),
                    items: _years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedYear = val;
                        if (_selectedYear == 'First Year') {
                          isFirstYearSelected = true;
                        } else {
                          isFirstYearSelected = false;
                        }
                      });
                      print(_selectedYear);
                    },
                    value: _selectedYear,
                    style: TextStyle(
                        color: darktheme ? Colors.white : Colors.black,
                        fontSize: 17.0),
                    dropdownColor:
                        darktheme ? Colors.grey[850] : Colors.grey[50],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    color: darktheme ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: darktheme ? Colors.grey[850] : Colors.grey[50],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: darktheme ? Colors.grey[850] : Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: darktheme ? Colors.grey[850] : Colors.grey,
                        width: 3.0,
                      ),
                    ),
                    labelText: 'Section',
                    labelStyle: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
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
                isFirstYearSelected == false
                    ? Container(
                        padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                            color:
                                darktheme ? Colors.grey[850] : Colors.grey[50]),
                        child: DropdownButton(
                          underline: Divider(color: Colors.transparent),
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
                          style: TextStyle(
                              color: darktheme ? Colors.white : Colors.black,
                              fontSize: 17.0),
                          dropdownColor:
                              darktheme ? Colors.grey[850] : Colors.grey[50],
                        ),
                      )
                    : Offstage(),
                SizedBox(
                  height: 15,
                ),
                ...days.map((e) => ListTile(
                      title: Text(
                        e,
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black,
                        ),
                      ),
                      leading: Icon(Icons.event,
                          color: darktheme ? Colors.white : Colors.grey),
                      trailing: Icon(Icons.chevron_right,
                          color: darktheme ? Colors.white : Colors.grey),
                      onTap: () {
                        if (_formKey.currentState.validate() ||
                            section != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSubjects(
                                    _selectedYear, _selectedBranch, section, e),
                              ));
                        }
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddSubjects extends StatefulWidget {
  final String year;
  final String branch;
  final String section;
  final String day;
  AddSubjects(this.year, this.branch, this.section, this.day);
  @override
  _AddSubjectsState createState() =>
      _AddSubjectsState(year, branch, section, day);
}

class _AddSubjectsState extends State<AddSubjects> {
  var year, branch, section, day, subject;
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List timetable = [];
  var times;

  _AddSubjectsState(this.year, this.branch, this.section, this.day);
  @override
  void initState() {
    super.initState();
    print(year + " " + branch + " " + section + " " + day);
    getTimetable();
  }

  getTimetable() async {
    if (year != 'First Year')
      await Firestore.instance
          .collection('/timetable')
          .document('$year')
          .collection('$branch')
          .document("$section")
          .get()
          .then((value) {
        setState(() {
          // print(value.data["$day"] != null);
          if (value.data["$day"] != null) timetable = value.data['$day'];
          print(timetable);
        });
      }).catchError((e) => print(e));
    else {
      await Firestore.instance
          .collection('/timetable')
          .document('$year')
          .collection('$section')
          .document('timetable')
          .get()
          .then((value) {
        setState(() {
          // print(value.data["$day"] != null);
          if (value.data["$day"] != null) timetable = value.data['$day'];
          print(timetable);
        });
      }).catchError((e) => print(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        elevation: 0,
        title: Text(day,
            style: GoogleFonts.montserrat(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: darktheme ? Colors.grey[100] : Colors.grey[900])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: darktheme ? Colors.white : Colors.black),
              // decoration: InputDecoration(labelText: 'Subject Name'),
              decoration: InputDecoration(
                filled: true,
                fillColor: darktheme ? Colors.grey[850] : Colors.grey[50],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: darktheme ? Colors.grey[850] : Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: darktheme ? Colors.grey[850] : Colors.grey,
                    width: 3.0,
                  ),
                ),
                labelText: 'Subject Name',
                labelStyle: TextStyle(
                  color: darktheme ? Colors.white : Colors.black,
                ),
                contentPadding: EdgeInsets.all(20.0),
                // hintText: section,
                // hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (val) {
                setState(() {
                  subject = val;
                });
              },
            ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey[850], width: 1.0),
            //     borderRadius: BorderRadius.circular(30.0),
            //     color: Colors.grey[850],
            //   ),
            //   child: DropdownButton(
            //     underline: Divider(color: Colors.grey[850]),
            //     isExpanded: false,
            //     items: subjects.map((value) {
            //       return DropdownMenuItem(
            //           child: Text(
            //             value,
            //             style: TextStyle(fontSize: height * 0.0148),
            //           ),
            //           value: value);
            //     }).toList(),
            //     onChanged: (val) {
            //       setState(() {
            //         subject = val;
            //       });
            //       print(subject);
            //     },
            //     value: subject,
            //     style: TextStyle(color: Colors.white, fontSize: 17.0),
            //     dropdownColor: Colors.grey[850],
            //   ),
            // ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  selectedTime == null
                      ? time.format(context)
                      : selectedTime.format(context),
                  style: TextStyle(
                    color: darktheme ? Colors.white : Colors.black,
                    fontSize: height * 0.03,
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    time = await showTimePicker(
                      context: context,
                      initialTime: time,
                    );
                    setState(() {
                      selectedTime = time;
                      time = TimeOfDay.now();
                    });
                    // print(selectedTime.format(context));
                  },
                  child: Text("Select Time"),
                ),
              ],
            ),
            Divider(),
            // Container(
            //   padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey[850], width: 1.0),
            //     borderRadius: BorderRadius.circular(30.0),
            //     color: Colors.grey[850],
            //   ),
            //   child: DropdownButton(
            //     underline: Divider(color: Colors.grey[850]),
            //     isExpanded: false,
            //     items: times.map((value) {
            //       return DropdownMenuItem(
            //           child: Text(
            //             value,
            //             style: TextStyle(fontSize: height * 0.0148),
            //           ),
            //           value: value);
            //     }).toList(),
            //     onChanged: (val) {
            //       setState(() {
            //         time = val;
            //       });
            //       print(time);
            //     },
            //     value: time,
            //     style: TextStyle(color: Colors.white, fontSize: 17.0),
            //     dropdownColor: Colors.grey[850],
            //   ),
            // ),
            RaisedButton(
              onPressed: () async {
                if (subject != null) {
                  timetable.add(
                      '$subject\r${selectedTime.format(context)}\rNo Details Available');
                  if (year != 'First Year')
                    await Firestore.instance
                        .collection('/timetable')
                        .document('$year')
                        .collection('$branch')
                        .document('$section')
                        .setData({'$day': timetable}, merge: true).then((e) {
                      print('Data Set');
                      getTimetable();
                    }).catchError((e) => print(e));
                  else
                    await Firestore.instance
                        .collection('/timetable')
                        .document('$year')
                        .collection('$section')
                        .document('timetable')
                        .setData({'$day': timetable}, merge: true).then((e) {
                      print('Data Set');
                      getTimetable();
                    }).catchError((e) => print(e));
                }
              },
              child: Text('Add'),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('CLASSES',
                  style: GoogleFonts.montserrat(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: darktheme ? Colors.grey[100] : Colors.grey[900])),
            ),
            ...timetable.map((event) => Dismissible(
                  key: Key(event.toString()),
                  background: Card(
                    color: darktheme ? Colors.teal : Colors.grey,
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 1.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 20.0),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      timetable.remove(event);
                      removeEvent(timetable);
                      // scaffoldKey.currentState.showSnackBar(SnackBar(
                      //     content: Text('Event Deleted'),
                      //     duration: Duration(milliseconds: 500),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(15.0),
                      //       topRight: Radius.circular(15.0),
                      //     ))));
                    });
                  },
                  child: Card(
                    elevation: 5.0,
                    color: darktheme ? Colors.grey[850] : Colors.white,
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 1.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ListTile(
                      title: Text(
                          event
                              .toString()
                              .substring(0, event.toString().indexOf('\r')),
                          style: TextStyle(
                              color: darktheme ? Colors.white : Colors.black)),
                      subtitle: Text(
                          event.toString().substring(
                              event.toString().indexOf('\r') + 1,
                              event.toString().lastIndexOf('\r')),
                          style: TextStyle(
                              color: darktheme ? Colors.white : Colors.black)),
                      leading: Icon(
                        Icons.event,
                        color: darktheme ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void removeEvent(List timetable) async {
    if (year != 'First Year')
      await Firestore.instance
          .collection('/timetable')
          .document('$year')
          .collection('$branch')
          .document('$section')
          .setData({'$day': timetable}, merge: true)
          .then((value) => print('Deleted'))
          .catchError((e) => print(e));
    else
      await Firestore.instance
          .collection('/timetable')
          .document('$year')
          .collection('$section')
          .document('timetable')
          .setData({'$day': timetable}, merge: true)
          .then((e) => print('Deleted'))
          .catchError((e) => print(e));
  }
}
