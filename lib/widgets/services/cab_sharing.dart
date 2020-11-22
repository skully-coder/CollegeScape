import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manipalleaks/widgets/services/manipalServices.dart';
import 'package:manipalleaks/main.dart';

class CabSharing extends StatefulWidget {
  @override
  _CabSharingState createState() => _CabSharingState();
}

class _CabSharingState extends State<CabSharing> {
  String name;
  String email;
  String phone;
  var modeoftravel = ['Plane', 'Train', 'Bus'];
  String selectedmodeoftravel = 'Plane';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  var messages;
  bool recievedMessages;

  String destination;

  var timeofday = ["A.M", "P.M"];
  var selectedTimeofday = "A.M";

  String boardingTime;

  DateTime dateoftravel = DateTime.now();

  DateTime selecteddateoftravel = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay time = TimeOfDay.now();
  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  var revmessages;
  getMessageList() async {
    await Firestore.instance
        .collection('/services')
        .document('Cab Sharing')
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        title: Text(
          'Cab Sharing',
          style: TextStyle(
            fontSize: 18.0,
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 500.0,
                    padding: EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 2.0),
                    decoration: BoxDecoration(
                        color: darktheme ? Colors.grey[800] : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: darktheme ? Colors.transparent : Colors.grey,
                            blurRadius: 2.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30.0)),
                    child: DropdownButton(
                      dropdownColor:
                          darktheme ? Colors.grey[800] : Colors.white,
                      underline: Divider(
                        color: darktheme ? Colors.grey[800] : Colors.white,
                        thickness: 0.0,
                        height: 0.0,
                      ),
                      isExpanded: false,
                      items: modeoftravel.map((value) {
                        return DropdownMenuItem(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: darktheme ? Colors.white : Colors.black,
                              ),
                            ),
                            value: value);
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedmodeoftravel = val;
                        });
                        // print(selectedmodeoftravel);
                      },
                      value: selectedmodeoftravel,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Container(
                //         width: width * 0.4,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(30.0),
                //           boxShadow: [
                //             BoxShadow(
                //               color:
                //                   darktheme ? Colors.transparent : Colors.grey,
                //               blurRadius: 2.0,
                //             ),
                //           ],
                //         ),
                //         child: TextFormField(
                //           keyboardType: TextInputType.datetime,
                //           style: TextStyle(
                //             color: darktheme ? Colors.white : Colors.black,
                //           ),
                //           decoration: InputDecoration(
                //             filled: true,
                //             fillColor:
                //                 darktheme ? Colors.grey[800] : Colors.white,
                //             focusedErrorBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(30.0),
                //               borderSide: BorderSide(
                //                 color:
                //                     darktheme ? Colors.grey[800] : Colors.white,
                //                 width: 3.0,
                //               ),
                //             ),
                //             errorBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(30.0),
                //               borderSide: BorderSide(
                //                 color: Colors.red,
                //                 width: 1.0,
                //               ),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(30.0),
                //               borderSide: BorderSide(
                //                 color:
                //                     darktheme ? Colors.grey[800] : Colors.white,
                //                 width: 1.0,
                //               ),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(30.0),
                //               borderSide: BorderSide(
                //                 color:
                //                     darktheme ? Colors.grey[800] : Colors.white,
                //                 width: 3.0,
                //               ),
                //             ),
                //             hintText: 'Boarding Time',
                //             hintStyle: TextStyle(
                //                 color: darktheme
                //                     ? Colors.white
                //                     : Colors.grey[600]),
                //             contentPadding: EdgeInsets.all(20.0),
                //           ),
                //           validator: (val) => val == null || val.length == 0
                //               ? 'Please enter boarding time'
                //               : null,
                //           onChanged: (val) {
                //             setState(() {
                //               boardingTime = val;
                //             });
                //           },
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           padding: EdgeInsets.fromLTRB(12.0, 2.0, 0.0, 2.0),
                //           decoration: BoxDecoration(
                //               boxShadow: [
                //                 BoxShadow(
                //                   color: darktheme
                //                       ? Colors.transparent
                //                       : Colors.grey,
                //                   blurRadius: 2.0,
                //                 ),
                //               ],
                //               color:
                //                   darktheme ? Colors.grey[800] : Colors.white,
                //               border: Border.all(
                //                   color: darktheme
                //                       ? Colors.grey[800]
                //                       : Colors.white,
                //                   width: 1.0),
                //               borderRadius: BorderRadius.circular(30.0)),
                //           child: DropdownButton(
                //             dropdownColor:
                //                 darktheme ? Colors.grey[800] : Colors.white,
                //             underline: Divider(
                //               color:
                //                   darktheme ? Colors.grey[800] : Colors.white,
                //               thickness: 0.0,
                //               height: 0.0,
                //             ),
                //             isExpanded: false,
                //             items: timeofday.map((value) {
                //               return DropdownMenuItem(
                //                   child: Text(
                //                     value,
                //                     style: TextStyle(fontSize: 15.0),
                //                   ),
                //                   value: value);
                //             }).toList(),
                //             onChanged: (val) {
                //               setState(() {
                //                 selectedTimeofday = val;
                //               });
                //               // print(selectedTimeofday);
                //             },
                //             value: selectedTimeofday,
                //             style: TextStyle(
                //                 color: darktheme ? Colors.white : Colors.black,
                //                 fontSize: 17.0),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: darktheme ? Colors.transparent : Colors.grey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          selectedTime == null
                              ? time.format(context)
                              : selectedTime.format(context),
                          style: GoogleFonts.montserrat(
                              fontSize: 17.0,
                              color: darktheme
                                  ? Colors.grey[100]
                                  : Colors.grey[900]),
                        ),
                        RaisedButton(
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
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
                          child: Text(
                            "Select Time",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: darktheme ? Colors.transparent : Colors.grey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          selecteddateoftravel != null
                              ? selecteddateoftravel.day.toString() +
                                  "/" +
                                  selecteddateoftravel.month.toString() +
                                  "/" +
                                  selecteddateoftravel.year.toString()
                              : dateoftravel.day.toString() +
                                  "/" +
                                  dateoftravel.month.toString() +
                                  "/" +
                                  dateoftravel.year.toString(),
                          style: GoogleFonts.montserrat(
                              fontSize: 17.0,
                              color: darktheme
                                  ? Colors.grey[100]
                                  : Colors.grey[900]),
                        ),
                        RaisedButton(
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () async {
                            dateoftravel = await showDatePicker(
                                context: context,
                                initialDate: dateoftravel,
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2070),
                                currentDate: dateoftravel);
                            setState(() {
                              selecteddateoftravel = dateoftravel;
                              dateoftravel = DateTime.now();
                              print(dateoftravel);
                            });
                          },
                          child: Text(
                            'Select Date',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: darktheme ? Colors.grey[800] : Colors.white,
                //       borderRadius: BorderRadius.circular(30.0),
                //       boxShadow: [
                //         BoxShadow(
                //           color: darktheme ? Colors.transparent : Colors.grey,
                //           blurRadius: 2.0,
                //         ),
                //       ],
                //     ),
                //     child: TextFormField(
                //       keyboardType: TextInputType.datetime,
                //       style: TextStyle(
                //         color: darktheme ? Colors.white : Colors.black,
                //       ),
                //       decoration: InputDecoration(
                //         focusedErrorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(30.0),
                //           borderSide: BorderSide(
                //             color: darktheme ? Colors.grey[800] : Colors.white,
                //             width: 3.0,
                //           ),
                //         ),
                //         errorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(30.0),
                //           borderSide: BorderSide(
                //             color: Colors.red,
                //             width: 1.0,
                //           ),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(30.0),
                //           borderSide: BorderSide(
                //             color: darktheme ? Colors.grey[800] : Colors.white,
                //             width: 1.0,
                //           ),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(30.0),
                //           borderSide: BorderSide(
                //             color: darktheme ? Colors.grey[800] : Colors.white,
                //             width: 3.0,
                //           ),
                //         ),
                //         hintText: 'Date of Travel',
                //         hintStyle: TextStyle(
                //           color: darktheme ? Colors.white : Colors.grey[600],
                //         ),
                //         contentPadding: EdgeInsets.all(20.0),
                //       ),
                //       validator: (val) => val == null || val.length == 0
                //           ? 'Please enter date of travel'
                //           : null,
                //       onChanged: (val) {
                //         setState(() {
                //           dateoftravel = val;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: darktheme ? Colors.transparent : Colors.grey,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: darktheme ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: darktheme ? Colors.grey[800] : Colors.white,
                            width: 3.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
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
                        hintText: 'Destination',
                        hintStyle: TextStyle(
                          color: darktheme ? Colors.white : Colors.grey[600],
                        ),
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      validator: (val) => val == null || val.length == 0
                          ? 'Please enter destination'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          destination = val;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: darktheme ? Colors.grey[800] : Colors.white,
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
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: darktheme ? Colors.grey[800] : Colors.white,
                            width: 3.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
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
                  color: Colors.teal,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      var text =
                          'Mode of Travel: $selectedmodeoftravel\nDate of Travel: ${selecteddateoftravel.day.toString()}/${selecteddateoftravel.month.toString()}/${selecteddateoftravel.year.toString()}\nBoarding Time: ${selectedTime.format(context)}\nDestination: $destination\nEmail: $email\nPhone Number: $phone';
                      revmessages.add('$name \n$text');
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/services')
                          .document('Cab Sharing')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        print('Data Set');
                        ManipalServices('Cab Sharing')
                            .createState()
                            .getMessageList();
                      }).catchError((e) => print(e));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Add',
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
