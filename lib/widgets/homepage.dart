import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manipalleaks/drawerWidgets/account.dart';
import 'package:manipalleaks/timetable/add_timetable.dart';
import 'package:manipalleaks/widgets/services/manipalServices.dart';
import 'package:manipalleaks/widgets/messages.dart';
import 'package:manipalleaks/authentication/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../notes/firstYear.dart';
import '../notes/secondYear.dart';
import 'portal_links.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../main.dart';
import 'package:manipalleaks/authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:clay_containers/clay_containers.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static CalendarController _controller;
  TabController _tabcontroller;
  // PageController _pageController;
  var _events = {};
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> _dateEvents;
  var isUserDetailsLoaded = false;
  var isUserEventsLoaded = false;
  SharedPreferences prefs;
  List<String> tabname = [
    "Updates",
    "My Calendar",
    "Services",
    "Portals",
    "Google Drive Notes",
  ];
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid;
  var uemail;
  var addedString = "";
  var channelnames = ["Year", "Section", "Club"];
  var servicenames = [
    "Room Sharing",
    "Cab Sharing",
    "Market Place",
    "Lost & Found"
  ];
  var year = '';
  var branch = '';
  List<String> years = [
    "First Year",
    "Second Year",
    "Third Year",
    "Fourth Year"
  ];
  var section = '';
  var uname = '';
  bool isGetChannelNames = false;
  var selectedtimeofday = 'A.M';
  var timeofday = ['A.M', 'P.M'];
  String eventTitle;
  String eventTime;
  String eventDetail;
  final GlobalKey<FormState> _formkey = GlobalKey();
  String addedevent;
  String eventTimeHour = '12';
  String eventTimeMinute = '00';
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay time = TimeOfDay.now();
  var timetable = [];
  var adminL1;
  var usersection;
  var useryear;
  var userbranch;
  bool isWeekdayLoaded;
  var weekday;
  var istimetableLoaded;

  bool showTips = true;

  List tips = [
    'To add events to your Calendar click on the \'Add\' Button and enter the respective fields',
    'To navigate to different sections on the app, tap on the corresponding icons in the bottom',
    'To view your account details, navigate to Menu > Account Settings',
    'To change your profile picture, navigate to Menu > Account Settings > Tap on the picture beside your name > Click on \'+\'',
    'To subscribe to the notification channel of section, navigate to Menu > Account Settings ? Edit User Profile > Type in your section'
  ];

  @override
  void initState() {
    super.initState();
    // _pageController =
    //     PageController(initialPage: _currentIndex, keepPage: true);
    _controller = CalendarController();
    weekday = DateTime.now().weekday;
    print(weekday);
    _selectedEvents = [];
    _tabcontroller = TabController(length: 3, vsync: this);
    _tabcontroller.index = 0;
    initPrefs();
    getCurrentUserName().whenComplete(() {
      getTimtable();
      getEvent();
    });
    getChannelName();

    // getTimtable();
    print(DateTime.utc(2020, 8, 3, 12));
  }

  @override
  void dispose() {
    super.dispose();
    _tabcontroller.dispose();
  }

  getChannelName() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        year = value.data['year'];
        if (year == 'First Year') {
          year = '1st Year';
        } else if (year == "Second Year") {
          year = "2nd Year";
        } else if (year == "Third Year") {
          year = "3rd Year";
        } else if (year == "Fourth Year") {
          year = "4th Year";
        }
        branch = value.data['branch'];
        section = value.data['section'];
        if (value.data['year'] == 'First Year') {
          channelnames[1] = "$year-${section.toUpperCase()}";
        } else {
          channelnames[1] =
              "$year-${branch.substring(0, branch.indexOf(':'))}-${section.toUpperCase()}";
        }
        channelnames[0] = year;
        // print(channelnames);
        isGetChannelNames = true;
      });
    }).catchError((e) => print(e));
  }

  Future getCurrentUserName() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      uname = value.data['name'];
      uemail = value.data['email'];
      adminL1 = value.data['adminL1'];
      isUserDetailsLoaded = true;
      useryear = value.data['year'];
      userbranch = value.data['branch'];
      usersection = value.data['section'].toString().toUpperCase();
    }).catchError((e) => print(e));
    // print(uname);
    // print(isUserDetailsLoaded);
  }

  getTimtable() async {
    print(useryear);
    if (useryear != 'First Year') {
      await Firestore.instance
          .collection('/timetable')
          .document('$useryear')
          .collection('$userbranch')
          .document('$usersection')
          .get()
          .then((value) {
        setState(() {
          // monday = value.data['Monday'];
          // tuesday = value.data['Tuesday'];
          timetable.add(value.data['Monday']);
          timetable.add(value.data['Tuesday']);
          timetable.add(value.data['Wednesday']);
          timetable.add(value.data['Thursday']);
          timetable.add(value.data['Friday']);
          timetable.add(value.data['Saturday']);
          istimetableLoaded = true;
          // timetable.add(monday);
          print(timetable);
          // print(monday.toString());
          // print(tuesday);
        });
      }).catchError((e) => print(e));
    } else {
      await Firestore.instance
          .collection('timetable')
          .document('$useryear')
          .collection('$usersection')
          .document('timetable')
          .get()
          .then((value) {
        setState(() {
          if (value.data['Monday'] != null) timetable.add(value.data['Monday']);
          if (value.data['Tuesday'] != null)
            timetable.add(value.data['Tuesday']);
          if (value.data['Wednesday'] != null)
            timetable.add(value.data['Wednesday']);
          if (value.data['Thursday'] != null)
            timetable.add(value.data['Thursday']);
          if (value.data['Friday'] != null) timetable.add(value.data['Friday']);
          if (value.data['Saturday'] != null)
            timetable.add(value.data['Saturday']);
          istimetableLoaded = true;

          print(timetable);
        });
      }).catchError((e) => print(e));
    }
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      showTips =
          prefs.getBool("showTips") == null ? true : prefs.getBool('showTips');
      _dateEvents = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      if (key != "null") newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _controller.isSelected(date)
            ? (darktheme ? Colors.grey[850] : Colors.white)
            : _controller.isToday(date)
                ? (darktheme ? Colors.teal : Colors.teal)
                : (darktheme ? Colors.teal : Colors.teal),
      ),
      width: 7.0,
      height: 7.0,
      // child: Center(
      //   child: Text(
      //     '${events.length}',
      //     style: TextStyle().copyWith(
      //       color: _controller.isSelected(date)
      //           ? Colors.white
      //           : _controller.isToday(date)
      //               ? Colors.white
      //               : darktheme ? Colors.white : Colors.black,
      //       fontSize: 12.0,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _showEventCalendar() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
            child: Text('\n\tWelcome ' + uname + "!\n",
                style: GoogleFonts.montserrat(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: darktheme ? Colors.grey[100] : Colors.grey[900])),
          ),
          showTips == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: darktheme ? Colors.grey[850] : Colors.white,
                    child: Column(
                      children: [
                        showTips == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\t\tTips',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                            color: darktheme
                                                ? Colors.grey[100]
                                                : Colors.grey[900])),
                                    IconButton(
                                        icon: Icon(Icons.close,
                                            color: darktheme
                                                ? Colors.grey[100]
                                                : Colors.grey[900]),
                                        onPressed: () {
                                          setState(() {
                                            showTips = false;
                                            prefs.setBool("showTips", showTips);
                                          });
                                        })
                                  ],
                                ),
                              )
                            : SizedBox(),
                        showTips == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 100.0,
                                  child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tips.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Container(
                                      width: 250.0,
                                      child: Card(
                                        elevation: 6.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        color: darktheme
                                            ? Colors.grey[800]
                                            : Colors.white,
                                        child: ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Tip ${index + 1}',
                                                  style: TextStyle(
                                                      color: darktheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Icon(
                                                Icons.lightbulb_outline,
                                                color: Colors.yellow,
                                              )
                                            ],
                                          ),
                                          subtitle: Text(tips[index],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  color: darktheme
                                                      ? Colors.white
                                                      : Colors.black)),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: darktheme
                                                    ? Colors.grey[850]
                                                    : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Tip',
                                                        style: TextStyle(
                                                            color: darktheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Icon(
                                                      Icons.lightbulb_outline,
                                                      color: Colors.yellow,
                                                    )
                                                  ],
                                                ),
                                                content: Text(tips[index],
                                                    style: TextStyle(
                                                      color: darktheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                actions: [
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('OK'),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          // showTips == true
          //     ? Padding(
          //         padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text('\t\tTips',
          //                 style: GoogleFonts.montserrat(
          //                     fontSize: 17.0,
          //                     fontWeight: FontWeight.bold,
          //                     color: darktheme
          //                         ? Colors.grey[100]
          //                         : Colors.grey[900])),
          //             IconButton(
          //                 icon: Icon(Icons.close),
          //                 onPressed: () {
          //                   setState(() {
          //                     showTips = false;
          //                     prefs.setBool("showTips", showTips);
          //                   });
          //                 })
          //           ],
          //         ),
          //       )
          //     : SizedBox(),
          // showTips == true
          //     ? Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: SizedBox(
          //           height: 100.0,
          //           child: ListView.builder(
          //             physics: ClampingScrollPhysics(),
          //             shrinkWrap: true,
          //             scrollDirection: Axis.horizontal,
          //             itemCount: tips.length,
          //             itemBuilder: (BuildContext context, int index) =>
          //                 Container(
          //               width: 250.0,
          //               child: Card(
          //                 elevation: 6.0,
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(10.0)),
          //                 color: darktheme ? Colors.grey[850] : Colors.white,
          //                 child: ListTile(
          //                   title: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text('Tip ${index + 1}',
          //                           style: TextStyle(
          //                               color: darktheme
          //                                   ? Colors.white
          //                                   : Colors.black,
          //                               fontWeight: FontWeight.bold)),
          //                       Icon(
          //                         Icons.lightbulb_outline,
          //                         color: Colors.yellow,
          //                       )
          //                     ],
          //                   ),
          //                   subtitle: Text(tips[index],
          //                       overflow: TextOverflow.ellipsis,
          //                       maxLines: 3,
          //                       style: TextStyle(
          //                           color: darktheme
          //                               ? Colors.white
          //                               : Colors.black)),
          //                   onTap: () {
          //                     showDialog(
          //                       context: context,
          //                       builder: (context) => AlertDialog(
          //                         backgroundColor: darktheme
          //                             ? Colors.grey[850]
          //                             : Colors.white,
          //                         shape: RoundedRectangleBorder(
          //                             borderRadius:
          //                                 BorderRadius.circular(20.0)),
          //                         title: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Text('Tip',
          //                                 style: TextStyle(
          //                                     color: darktheme
          //                                         ? Colors.white
          //                                         : Colors.black,
          //                                     fontWeight: FontWeight.bold)),
          //                             Icon(
          //                               Icons.lightbulb_outline,
          //                               color: Colors.yellow,
          //                             )
          //                           ],
          //                         ),
          //                         content: Text(tips[index],
          //                             style: TextStyle(
          //                               color: darktheme
          //                                   ? Colors.white
          //                                   : Colors.black,
          //                             )),
          //                         actions: [
          //                           FlatButton(
          //                             onPressed: () {
          //                               Navigator.pop(context);
          //                             },
          //                             child: Text('OK'),
          //                           )
          //                         ],
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : SizedBox(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                color: darktheme ? Colors.grey[850] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: darktheme ? Colors.transparent : Colors.grey,
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: TableCalendar(
                initialCalendarFormat: CalendarFormat.twoWeeks,
                initialSelectedDay: DateTime.now(),
                events: _dateEvents,
                calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    markersColor: darktheme ? Colors.white : Colors.black,
                    markersMaxAmount: 1,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  leftChevronIcon: Icon(Icons.chevron_left,
                      color: darktheme ? Colors.white : Colors.black),
                  rightChevronIcon: Icon(Icons.chevron_right,
                      color: darktheme ? Colors.white : Colors.black),
                  titleTextStyle: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: darktheme ? Colors.teal : Colors.teal,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  weekendStyle: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                // onDayLongPressed: (date, events) {
                //   _showDaySelectedEvents(date, events);
                // },
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedEvents = events;
                    weekday = _controller.selectedDay.weekday;
                    // print(_selectedEvents.toString());
                    if (events.toString() == "[]") {
                      addedString = "\n\t\t\tNo Events To Show";
                    } else
                      addedString = "";
                  });
                },
                builders: CalendarBuilders(
                  markersBuilder: (context, date, events, holidays) {
                    final children = <Widget>[];
                    if (events.isNotEmpty) {
                      children.add(
                        Positioned(
                          height: 80,
                          top: 5.0,
                          child: _buildEventsMarker(date, events),
                        ),
                      );
                    }
                    return children;
                  },
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darktheme ? Colors.teal : Colors.teal,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              darktheme ? Colors.grey[900] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      )),
                  dayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darktheme ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      )),
                  outsideDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darktheme ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: darktheme ? Colors.grey[700] : Colors.grey),
                      )),
                  weekendDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darktheme ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      )),
                  outsideWeekendDayBuilder: (context, date, events) =>
                      Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:
                                  darktheme ? Colors.grey[850] : Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                                color:
                                    darktheme ? Colors.grey[700] : Colors.grey),
                          )),
                ),
                calendarController: _controller,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            color: darktheme ? Colors.grey[900] : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
                    child: RichText(
                      text: TextSpan(
                          text: "\tEvents",
                          style: GoogleFonts.montserrat(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: darktheme
                                  ? Colors.grey[100]
                                  : Colors.grey[900]),
                          children: [
                            TextSpan(
                              text: addedString,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.0,
                                  color: darktheme
                                      ? Colors.grey[100]
                                      : Colors.grey[900]),
                            )
                          ]),
                    ),
                  ),
                  // child: Text('\tEvents : \t$addedString',
                  //     textAlign: TextAlign.start,
                  //     style: GoogleFonts.montserrat(
                  //         fontSize: 17.0,
                  //         fontWeight: FontWeight.bold,
                  //         color: darktheme
                  //             ? Colors.grey[100]
                  //             : Colors.grey[900])),
                  // ),
                  ..._selectedEvents.map((event) => Dismissible(
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
                            _selectedEvents.remove(event);
                            removeEvent(_controller.selectedDay, event);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Event Deleted'),
                                duration: Duration(milliseconds: 500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ))));
                            if (_selectedEvents.toString() == '[]') {
                              addedString = "\n\t\t\tNo Events To Show";
                            }
                            prefs.clear();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: Text(
                                  event.toString().substring(
                                      0, event.toString().indexOf('\r')),
                                  style: TextStyle(
                                      color: darktheme
                                          ? Colors.white
                                          : Colors.black)),
                              subtitle: Text(
                                  event.toString().substring(
                                      event.toString().indexOf('\r') + 1,
                                      event.toString().lastIndexOf('\r')),
                                  style: TextStyle(
                                      color: darktheme
                                          ? Colors.white
                                          : Colors.black)),
                              leading: Icon(
                                Icons.event,
                                color:
                                    darktheme ? Colors.white : Colors.grey[600],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    _createRoute(ShowEventDetails(event)));
                              },
                              trailing: GestureDetector(
                                  child: Icon(
                                    Icons.delete,
                                    color: darktheme
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedEvents.remove(event);
                                      removeEvent(
                                          _controller.selectedDay, event);
                                      if (_selectedEvents.toString() == '[]') {
                                        addedString =
                                            "\n\t\t\tNo Events To Show";
                                      }
                                      prefs.clear();
                                    });
                                  })),
                        ),
                      )),
                  weekday - 1 == 6
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
                          child: RichText(
                            text: TextSpan(
                                text: "\tTimetable: ",
                                style: GoogleFonts.montserrat(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: darktheme
                                        ? Colors.grey[100]
                                        : Colors.grey[900]),
                                children: [
                                  TextSpan(
                                    text: '\n\t\t\tNo Classes On This Day :)',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14.0,
                                        color: darktheme
                                            ? Colors.grey[100]
                                            : Colors.grey[900]),
                                  )
                                ]),
                          ),
                        )
                      : Offstage(),
                  displayTimetable()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          )
        ],
      ),
    );
  }

  int _currentIndex = 1;
  displayTimetable() {
    if ((weekday - 1) != 6 && istimetableLoaded == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
            child: Text('\tTimetable : ',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: darktheme ? Colors.grey[100] : Colors.grey[900])),
          ),
          ...timetable[weekday - 1].map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                      e.toString().substring(0, e.toString().indexOf('\r')),
                      style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black)),
                  subtitle: Text(
                      e.toString().substring(e.toString().indexOf('\r') + 1,
                          e.toString().lastIndexOf('\r')),
                      style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black)),
                  leading: Icon(
                    Icons.event,
                    color: darktheme ? Colors.white : Colors.grey[600],
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(_createRoute(ShowEventDetails(e)));
                  },
                ),
              )),
        ],
      );
    } else
      return Offstage();
  }

  Widget drawerTabs(var img, var name, var url) {
    return Container(
      decoration:
          BoxDecoration(color: darktheme ? Colors.grey[900] : Colors.white),
      child: InkWell(
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17.0,
              color: darktheme ? Colors.white : Colors.grey[600],
            ),
          ),
          leading: Icon(
            img,
            color: darktheme ? Colors.white : Colors.grey[600],
          ),
          onTap: () {
            _launchURL(url);
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<Null> _openUrl(String url, String urlName, context) async {
    if (await canLaunch(url)) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: darktheme ? Colors.grey[900] : Colors.teal,
                  title: Text(urlName),
                ),
                body: WebView(
                  initialUrl: url,
                ),
              )));
    }
  }

  buildDeveloperTile(
      var name,
      var role,
      var image,
      var github,
      var insta,
      var email,
      var whatsapp,
      var width,
      var githubUrl,
      var instaUrl,
      var emailUrl,
      var whatsappUrl) {
    print(width * 0.135);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          decoration: BoxDecoration(
            color: darktheme ? Colors.grey[850] : Colors.grey[200],
            borderRadius: BorderRadius.circular(15.0),
            // boxShadow: [
            //       BoxShadow(
            //         color: darktheme ? Colors.transparent : Colors.grey,
            //         blurRadius: 1.0,
            //       ),]
          ),
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(image),
                    radius: width * 0.23,
                  ),
                  Container(
                    height: width * 0.5,
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: darktheme
                                  ? Colors.grey[200]
                                  : Colors.grey[800],
                              fontSize: width * 0.14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          role,
                          style: GoogleFonts.montserrat(
                              color: darktheme ? Colors.grey : Colors.grey[600],
                              fontSize: width * 0.09,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 2.0),
                        Container(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              github == true
                                  ? GestureDetector(
                                      child: Icon(FontAwesome.github,
                                          color: darktheme
                                              ? Colors.grey[300]
                                              : Colors.grey[800],
                                          size: width * 0.135),
                                      onTap: () => _launchURL(githubUrl),
                                    )
                                  : SizedBox(
                                      width: width * 0.135,
                                    ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              email == true
                                  ? GestureDetector(
                                      child: Icon(Icons.mail_outline,
                                          color: darktheme
                                              ? Colors.grey[300]
                                              : Colors.grey[800],
                                          size: width * 0.135),
                                      onTap: () => _launchURL(emailUrl),
                                    )
                                  : SizedBox(
                                      width: width * 0.135,
                                    ),
                              insta == true
                                  ? GestureDetector(
                                      child: Icon(FontAwesome.instagram,
                                          color: darktheme
                                              ? Colors.grey[300]
                                              : Colors.grey[800],
                                          size: width * 0.135),
                                      onTap: () => _launchURL(instaUrl),
                                    )
                                  : SizedBox(
                                      width: width * 0.135,
                                    ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),

                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              whatsapp == true
                                  ? GestureDetector(
                                      child: Icon(FontAwesome.whatsapp,
                                          color: darktheme
                                              ? Colors.grey[300]
                                              : Colors.grey[800],
                                          size: width * 0.135),
                                      onTap: () => _launchURL(whatsappUrl),
                                    )
                                  : SizedBox(
                                      width: width * 0.135,
                                    ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  _buildDrawer() {
    double width = MediaQuery.of(context).size.width;
    return Theme(
      data: Theme.of(context)
          .copyWith(canvasColor: darktheme ? Colors.grey[900] : Colors.white),
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: darktheme ? Colors.grey[900] : Colors.white),
              accountName: Text('CollegeScape',
                  style: GoogleFonts.montserrat(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: darktheme ? Colors.grey[100] : Colors.grey[900])),
              accountEmail: InkWell(
                onTap: () {
                  _launchURL('mailto:collegescape@gmail.com');
                },
                child: Text(
                  'collegescape@gmail.com',
                  style:
                      TextStyle(color: darktheme ? Colors.white : Colors.black),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/shuvam logo.png'),
                backgroundColor: Colors.white,
                maxRadius: 60.0,
              ),
            ),
            ListTile(
              title: Text(
                'Dark Theme',
                style: TextStyle(
                    fontSize: 17.0,
                    color: darktheme ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(
                Icons.brightness_6,
                color: darktheme ? Colors.white : Colors.grey[600],
              ),
              trailing: Switch(
                  value: darktheme,
                  onChanged: (value) {
                    setState(() {
                      darktheme = !darktheme;
                    });
                  }),
            ),
            adminL1 == true
                ? Container(
                    decoration: BoxDecoration(
                        color: darktheme ? Colors.grey[900] : Colors.white),
                    child: InkWell(
                      child: ListTile(
                        title: Text(
                          'Add Timetable',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                            color: darktheme ? Colors.white : Colors.grey[600],
                          ),
                        ),
                        leading: Icon(
                          Icons.event,
                          color: darktheme ? Colors.white : Colors.grey[600],
                        ),
                        onTap: () {
                          Navigator.push(context, _createRoute(AddTimeTable()));
                        },
                      ),
                    ),
                  )
                : Offstage(),
            Divider(
              thickness: 2.0,
              color: darktheme ? Colors.grey[850] : Colors.grey[200],
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: darktheme ? Colors.grey[900] : Colors.white),
            //   child: InkWell(
            //     child: ListTile(
            //       title: Text(
            //         'Team',
            //         style: TextStyle(
            //           fontWeight: FontWeight.w400,
            //           fontSize: 17.0,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //       ),
            //       leading: Icon(Icons.code,
            //           color: darktheme ? Colors.white : Colors.grey[600]),
            //       onTap: () {
            //         showModalBottomSheet(
            //             isScrollControlled: true,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(30.0)),
            //             backgroundColor:
            //                 darktheme ? Colors.grey[900] : Colors.white,
            //             context: context,
            //             builder: (context) {
            //               return SingleChildScrollView(
            //                 child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                     children: [
            //                       Center(
            //                         child: Icon(FontAwesome.angle_down,
            //                             color: darktheme
            //                                 ? Colors.grey
            //                                 : Colors.grey[600]),
            //                       ),
            //                       SizedBox(
            //                         height: 10.0,
            //                       ),
            //                       Center(
            //                           child: Text(
            //                         'TEAM',
            //                         textAlign: TextAlign.center,
            //                         style: GoogleFonts.montserrat(
            //                             textStyle: TextStyle(
            //                                 fontSize: 20.0,
            //                                 fontWeight: FontWeight.w700,
            //                                 color: darktheme
            //                                     ? Colors.grey[200]
            //                                     : Colors.grey[800])),
            //                       )),
            //                       Divider(),
            //                       // SizedBox(
            //                       //   height: 20.0,
            //                       // ),
            //                       buildDeveloperTile(
            //                           'Abhinav Agrawal',
            //                           'Lead Developer',
            //                           'assets/Abhinav -3.jpeg',
            //                           true,
            //                           true,
            //                           true,
            //                           true,
            //                           width * 0.40,
            //                           'https://github.com/skully-coder',
            //                           'https://www.instagram.com/abhi_1.7.0.9/',
            //                           'mailto:abhinav.hfs@gmail.com',
            //                           'https://wa.me/918169809401'),
            //                       buildDeveloperTile(
            //                           'Shuvam Mandal',
            //                           'Project Head',
            //                           'assets/Shuvam.jpg',
            //                           true,
            //                           true,
            //                           true,
            //                           true,
            //                           width * 0.40,
            //                           'https://github.com/coffeeCoder69',
            //                           'https://www.instagram.com/shuvam_bhai/',
            //                           'mailto:mandalshuvam71@gmail.com',
            //                           'https://wa.me/919082268036'),
            //                       GridTile(
            //                         child: buildDeveloperTile(
            //                             'Aaditya Nair',
            //                             'Designer',
            //                             'assets/Aaditya.jpeg',
            //                             true,
            //                             false,
            //                             true,
            //                             false,
            //                             width * 0.40,
            //                             'https://github.com/aadinoir',
            //                             'https://www.instagram.com/aadityanair05/',
            //                             'mailto:aadityanair05@gmail.com',
            //                             'https://wa.me/919930222648'),
            //                       )
            //                     ]),
            //               );
            //             });
            //       },
            //     ),
            //   ),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: darktheme ? Colors.grey[900] : Colors.white),
            //   child: InkWell(
            //     child: AboutListTile(
            //       applicationVersion: 'v1.0.0',
            //       applicationIcon: Image.asset(
            //         'assets/rainbowtest.png',
            //         height: 40,
            //       ),
            //       icon: Icon(
            //         Icons.info,
            //         color: darktheme ? Colors.white : Colors.grey[600],
            //       ),
            //       child: Text(
            //         'Licenses',
            //         style: TextStyle(
            //           fontWeight: FontWeight.w400,
            //           fontSize: 17.0,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // drawerTabs(FontAwesome.bug, 'Report A Bug',
            //     'mailto:manipal.qpleaks@gmail.com?subject=Report%20A%20Bug'),
            // drawerTabs(Entypo.star, 'Rate the App',
            //     'https://play.google.com/store/apps/details?id=com.manipal.manipalleaks'),
            // Divider(
            //   thickness: 2.0,
            //   color: darktheme ? Colors.grey[850] : Colors.grey[200],
            // ),
            Container(
              decoration: BoxDecoration(
                  color: darktheme ? Colors.grey[900] : Colors.white),
              child: InkWell(
                child: ListTile(
                  title: Text(
                    'Explore Student Clubs',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      color: darktheme ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  leading: Icon(
                    Icons.explore,
                    color: darktheme ? Colors.white : Colors.grey[600],
                  ),
                  onTap: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => AlertDialog(
                    //     backgroundColor:
                    //         darktheme ? Colors.grey[850] : Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20.0)),
                    //     title: Text(
                    //       'Coming Soon',
                    //       style: TextStyle(
                    //         color: darktheme ? Colors.grey[200] : Colors.black,
                    //       ),
                    //     ),
                    //     content: Text('This feature is still in development',
                    //         style: TextStyle(
                    //           color:
                    //               darktheme ? Colors.grey[200] : Colors.black,
                    //         )),
                    //     actions: [
                    //       FlatButton(
                    //           onPressed: () => Navigator.of(context).pop(),
                    //           child: Text('OK'))
                    //     ],
                    //   ),
                    // );
                    _launchURL("https://clubs.mitportals.in");
                  },
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: darktheme ? Colors.grey[900] : Colors.white),
            //   child: InkWell(
            //     child: ListTile(
            //       title: Text(
            //         'Connect With Us',
            //         style: TextStyle(
            //           fontWeight: FontWeight.w400,
            //           fontSize: 17.0,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //       ),
            //       leading: Icon(
            //         Entypo.share,
            //         color: darktheme ? Colors.white : Colors.grey[600],
            //       ),
            //       onTap: () {
            //         // Navigator.push(context, _createRoute(Account()));
            //       },
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     SizedBox(
            //       width: width * 0.01,
            //     ),
            //     IconButton(
            //         icon: Icon(
            //           Entypo.mail,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //         onPressed: () =>
            //             _launchURL('mailto:manipal.qpleaks@gmail.com')),
            //     IconButton(
            //         icon: Icon(
            //           Feather.instagram,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //         onPressed: () =>
            //             _launchURL('https://www.instagram.com/manipalleaks/')),
            //     IconButton(
            //         icon: Icon(
            //           MaterialIcons.language,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //         onPressed: () =>
            //             _launchURL('http://manipalleaks.wtf/?i=1')),
            //     IconButton(
            //         icon: Icon(
            //           Entypo.youtube,
            //           color: darktheme ? Colors.white : Colors.grey[600],
            //         ),
            //         onPressed: () => _launchURL(
            //             'https://www.youtube.com/channel/UCRqzzYo6xm7aklQeV2ZZ1gw')),
            //   ],
            // ),
            Divider(
              thickness: 2.0,
              color: darktheme ? Colors.grey[850] : Colors.grey[200],
            ),
            Container(
              decoration: BoxDecoration(
                  color: darktheme ? Colors.grey[900] : Colors.white),
              child: InkWell(
                child: ListTile(
                  title: Text(
                    'Account Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      color: darktheme ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: darktheme ? Colors.white : Colors.grey[600],
                  ),
                  onTap: () {
                    Navigator.push(context, _createRoute(Account()));
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: darktheme ? Colors.grey[900] : Colors.white),
              child: InkWell(
                child: ListTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      color: darktheme ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  leading: Icon(
                    Icons.power_settings_new,
                    color: darktheme ? Colors.white : Colors.grey[600],
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor:
                                  darktheme ? Colors.grey[850] : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              title: Text(
                                'Confirm Sign Out',
                                style: TextStyle(
                                  color: darktheme
                                      ? Colors.grey[200]
                                      : Colors.black,
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to sign out ?",
                                style: TextStyle(
                                  color: darktheme
                                      ? Colors.grey[200]
                                      : Colors.black,
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () async {
                                      await _auth.signOut();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          _createRoute(SignIn()),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text('YES')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('NO'))
                              ],
                            ));
                  },
                ),
              ),
            ),
            Divider(
              thickness: 2.0,
              color: darktheme ? Colors.grey[850] : Colors.grey[200],
            )
          ],
        ),
      ),
    );
  }

//
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        bottom: _currentIndex == 0
            ? TabBar(
                labelColor: darktheme ? Colors.white : Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: false,
                controller: _tabcontroller,
                tabs: channelnames
                    .map((e) => Tab(
                          child: Text(
                            channelnames.indexOf(e) == 1
                                ? year != '1st Year'
                                    ? '${branch.substring(0, branch.toString().indexOf(':'))} - ${section.toUpperCase()}'
                                    : '${section.toUpperCase()}'
                                : e,
                            softWrap: true,
                          ),
                          // text: channelnames.indexOf(e) == 2
                          //     ? '${branch.substring(0, branch.toString().indexOf(':'))} - ${section.toUpperCase()}'
                          //     : e
                        ))
                    .toList())
            // : _currentIndex == 4
            //     ? TabBar(
            //         controller: _servicetabcontroller,
            //         isScrollable: true,
            //         indicatorSize: TabBarIndicatorSize.tab,
            //         tabs: servicenames
            //             .map((e) => Tab(
            //                   text: e,
            //                 ))
            //             .toList())
            : null,
        title: Text(
          tabname[_currentIndex],
          style: TextStyle(
            fontSize: 18.0,
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              tooltip: 'Add an Event',
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              mini: true,
              isExtended: true,
              onPressed: () {
                // print(_controller.selectedDay);
                // Navigator.of(context).push(_createRoute(AddEventDetails(
                //     _controller.selectedDay.toUtc().toString())));
                // _showAddDialog();
                _showAddSheet(context);
              },
              backgroundColor: Colors.teal,
              child: Icon(Icons.add))
          : null,
      drawer: _buildDrawer(),
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      // body: PageView(
      //   onPageChanged: (val) {
      //     setState(() {
      //       _currentIndex = val;
      //     });
      //   },
      //   controller: _pageController,
      //   scrollDirection: Axis.horizontal,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           ...years.map(
      //             (e) => Card(
      //                 color: darktheme ? Colors.blueGrey[900] : Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(12.0)),
      //                 shadowColor: Colors.black,
      //                 child: ListTile(
      //                   title: Text(
      //                     e,
      //                     style: TextStyle(
      //                         color: darktheme ? Colors.white : Colors.black),
      //                   ),
      //                   onTap: () {
      //                     switch (e) {
      //                       case "First Year":
      //                         Navigator.push(
      //                             context, _createRoute(FirstYear()));
      //                         break;
      //                       case "Second Year":
      //                         Navigator.push(
      //                             context, _createRoute(SecondYear()));
      //                         break;
      //                       default:
      //                     }
      //                   },
      //                 )),
      //           )
      //         ],
      //       ),
      //     ),
      //     showMessagePage(),
      //     _showEventCalendar(),
      //     PortalLinks(),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: GridView.count(
      //           crossAxisCount: 2,
      //           children: new List<Widget>.generate(
      //             4,
      //             (index) {
      //               return Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: new GridTile(
      //                   child: GestureDetector(
      //                       child: new Card(
      //                           color: darktheme
      //                               ? Colors.blueGrey[300]
      //                               : Colors.white,
      //                           child: new Center(
      //                             child: new Text(
      //                                 '${servicenames[index].toUpperCase()}'),
      //                           )),
      //                       onTap: () {
      //                         Navigator.of(context).push(_createRoute(
      //                             ManipalServices(servicenames[index])));
      //                       }),
      //                 ),
      //               );
      //             },
      //           )),
      //     ),
      //   ],
      // ),
      body: selectBodyTab(_currentIndex),

      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(
            Icons.message,
            color: Colors.grey,
          ),
          Icon(
            Icons.event,
            color: Colors.grey,
          ),
          Icon(
            Entypo.tools,
            color: Colors.grey,
          ),
          Icon(
            Icons.link,
            color: Colors.grey,
          ),
          Icon(
            Entypo.book,
            color: Colors.grey,
          ),
        ],
        height: height * 0.065,
        animationDuration: Duration(milliseconds: 200),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
        color: darktheme ? Colors.grey[850] : Colors.white,
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  selectBodyTab(index) {
    switch (index) {
      case 0:
        if (isGetChannelNames == true) {
          return TabBarView(
              controller: _tabcontroller,
              children: channelnames.map((e) {
                return Messages(e, channelnames);
              }).toList());
        } else
          return Center(child: CircularProgressIndicator());
        break;

      case 1:
        return _showEventCalendar();
        break;

      case 4:
        List<String> years = [
          "First Year",
          "Second Year",
          "Third Year",
          "Fourth Year"
        ];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...years.map(
                (e) => Card(
                    color: darktheme ? Colors.grey[850] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    shadowColor: Colors.black,
                    child: ListTile(
                      leading: Icon(Icons.folder,
                          color: darktheme ? Colors.white : Colors.grey),
                      title: Text(
                        e,
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      trailing: Icon(Icons.chevron_right,
                          color: darktheme ? Colors.white : Colors.grey),
                      onTap: () {
                        switch (e) {
                          case "First Year":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstYear()));
                            break;
                          case "Second Year":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SecondYear()));
                            break;
                          default:
                        }
                      },
                    )),
              )
            ],
          ),
        );
        break;
      case 3:
        return PortalLinks();
        break;
      case 2:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
              crossAxisCount: 2,
              children: new List<Widget>.generate(
                4,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new GridTile(
                      child: GestureDetector(
                          child: new Card(
                              elevation: 6.0,
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
                              child: new Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    servicenames[index].toUpperCase() ==
                                            'ROOM SHARING'
                                        ? Icon(
                                            FlutterIcons.bed_empty_mco,
                                            size: 50.0,
                                            color: darktheme
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        : servicenames[index].toUpperCase() ==
                                                'CAB SHARING'
                                            ? Icon(
                                                FlutterIcons.cab_faw,
                                                size: 50.0,
                                                color: darktheme
                                                    ? Colors.white
                                                    : Colors.black,
                                              )
                                            : servicenames[index]
                                                        .toUpperCase() ==
                                                    'MARKET PLACE'
                                                ? Icon(
                                                    Entypo.shop,
                                                    size: 50.0,
                                                    color: darktheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                  )
                                                : servicenames[index]
                                                            .toUpperCase() ==
                                                        'LOST & FOUND'
                                                    ? Icon(
                                                        FlutterIcons
                                                            .ios_umbrella_ion,
                                                        size: 50.0,
                                                        color: darktheme
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )
                                                    : Icon(Entypo.shopping_bag,
                                                        size: 50.0),
                                    new Text(
                                      '${servicenames[index].toUpperCase()}',
                                      style: TextStyle(
                                          color: darktheme
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                          onTap: () {
                            Navigator.of(context).push(_createRoute(
                                ManipalServices(servicenames[index])));
                          }),
                    ),
                  );
                },
              )),
        );
        break;
      default:
    }
  }

  getEvent() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      _events = value.data['events'];
      _dateEvents =
          _events.map((key, value) => MapEntry(DateTime.parse(key), value));
      // print('events: $_events');
      // print('dateEvents: $_dateEvents');
      print("Data Recieved");
      setState(() {
        if (_dateEvents[DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day, 17, 30)
                    .toUtc()] !=
                null &&
            _dateEvents[DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day, 17, 30)
                        .toUtc()]
                    .toString() !=
                '[]') {
          _selectedEvents = _dateEvents[DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 17, 30)
              .toUtc()];
          print(_selectedEvents);
          print(_selectedEvents);
          // print(DateTime(DateTime.now().year, DateTime.now().month,
          //         DateTime.now().day, 17, 30)
          //     .toUtc());
        } else {
          _selectedEvents = [];
          addedString = "\n\t\t\tNo Events To Show";
          print(_selectedEvents);
          // print(_controller.selectedDay);
        }
      });
      isUserEventsLoaded = true;
      // print(isUserEventsLoaded);
    }).catchError((e) => print(e));
    return _events;
  }

  addEvent(var event, var key, var dayEvents) async {
    var eventarr = dayEvents;
    final FirebaseUser user = await auth.currentUser();
    if (_events[key.toString()] == null) {
      eventarr = [event];
      // print('eventarr : $eventarr');
      _events = {'$key': eventarr};
      // print(_events);
      await Firestore.instance
          .collection('/users')
          .document(user.uid)
          .setData({'events': _events}, merge: true)
          .then((value) => print('Data Set'))
          .catchError((e) => print(e));
    } else {
      try {
        // print('eventarr : $eventarr');

        _events = {'$key': eventarr};
      } catch (e) {
        print(e);
      }
      // print('eventarr : $eventarr');
      // print(_events);
      await Firestore.instance
          .collection('/users')
          .document(user.uid)
          .setData({'events': _events}, merge: true).then((value) {
        print('Data Set');
      }).catchError((e) => print(e));
    }
  }

  removeEvent(var key, var event) async {
    final FirebaseUser user = await auth.currentUser();
    try {
      _events[key.toString()].remove(event);
    } catch (e) {
      print(e);
    }

    await Firestore.instance.collection('/users').document(user.uid).setData(
        {'events': _events},
        merge: true).then((value) => print("Data updated"));
  }

  _showAddSheet(context) {
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          // title: Text('Add Task'),
          // titleTextStyle: TextStyle(
          //   color: darktheme ? Colors.white : Colors.black,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 20.0,
          // ),
          backgroundColor: darktheme ? Colors.grey[850] : Colors.white,
          content: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    child: Center(
                      child: Text(
                        'Add Event',
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.grey[800],
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //height: 100.0,
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                          '${_controller.selectedDay.day} - ${_controller.selectedDay.month} - ${_controller.selectedDay.year}',
                          style: TextStyle(
                              color: darktheme ? Colors.grey : Colors.grey[600],
                              fontSize: 15.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black,
                        ),
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color:
                                darktheme ? Colors.grey[200] : Colors.grey[600],
                          ),
                          filled: true,
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.grey[200],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
                            ),
                          ),
                        ),
                        validator: (value) => value == null
                            ? 'Event Title cannot be blank'
                            : null,
                        onChanged: (value) {
                          setState(() {
                            eventTitle = value;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: darktheme ? Colors.grey[800] : Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            selectedTime == null
                                ? time.format(context)
                                : selectedTime.format(context),
                            style: TextStyle(
                                color: darktheme ? Colors.white : Colors.black),
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
                          // Padding(
                          //   padding: const EdgeInsets.all(4.0),
                          //   child: Container(
                          //     width: width * 0.1,
                          //     child: TextFormField(
                          //         initialValue: '12',
                          //         textInputAction: TextInputAction.next,
                          //         textAlignVertical: TextAlignVertical.top,
                          //         textAlign: TextAlign.center,
                          //         showCursor: true,
                          //         buildCounter: (context,
                          //                 {currentLength,
                          //                 isFocused,
                          //                 maxLength}) =>
                          //             null,
                          //         maxLength: 2,
                          //         style: TextStyle(
                          //           fontSize: 17.0,
                          //           color:
                          //               darktheme ? Colors.white : Colors.black,
                          //         ),
                          //         textCapitalization:
                          //             TextCapitalization.sentences,
                          //         keyboardType: TextInputType.number,
                          //         decoration: InputDecoration(
                          //           enabledBorder: InputBorder.none,
                          //         ),
                          //         validator: (value) => value == null
                          //             ? 'Time cannot be blank'
                          //             : int.parse(value) < 0 &&
                          //                     int.parse(value) > 12
                          //                 ? 'Hour should be between 0 and 12'
                          //                 : null,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             eventTimeHour = value;
                          //           });
                          //         }),
                          //   ),
                          // ),
                          // Text(
                          //   ' : ',
                          //   style: TextStyle(
                          //       color: darktheme ? Colors.white : Colors.black,
                          //       fontSize: 15.0),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(4.0),
                          //   child: Container(
                          //     width: width * 0.1,
                          //     child: TextFormField(
                          //         initialValue: '00',
                          //         textInputAction: TextInputAction.next,
                          //         textAlignVertical: TextAlignVertical.top,
                          //         textAlign: TextAlign.center,
                          //         showCursor: true,
                          //         buildCounter: (context,
                          //                 {currentLength,
                          //                 isFocused,
                          //                 maxLength}) =>
                          //             null,
                          //         maxLength: 2,
                          //         style: TextStyle(
                          //           fontSize: 17.0,
                          //           color:
                          //               darktheme ? Colors.white : Colors.black,
                          //         ),
                          //         textCapitalization:
                          //             TextCapitalization.sentences,
                          //         keyboardType: TextInputType.number,
                          //         decoration: InputDecoration(
                          //           enabledBorder: InputBorder.none,
                          //         ),
                          //         validator: (value) => value == null
                          //             ? 'Time cannot be blank'
                          //             : null,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             eventTimeMinute = value;
                          //           });
                          //         }),
                          //   ),
                          // ),
                          // Container(
                          //   child: DropdownButton(
                          //     dropdownColor:
                          //         darktheme ? Colors.grey[800] : Colors.white,
                          //     items: timeofday.map((value) {
                          //       return DropdownMenuItem(
                          //           child: Text(
                          //             value,
                          //             style: TextStyle(fontSize: 16.0),
                          //           ),
                          //           value: value);
                          //     }).toList(),
                          //     onChanged: (val) {
                          //       setState(() {
                          //         selectedtimeofday = val;
                          //       });
                          //       // print(selectedtimeofday);
                          //     },
                          //     value: selectedtimeofday,
                          //     underline: Divider(
                          //       thickness: 0.0,
                          //     ),
                          //     style: TextStyle(
                          //         color:
                          //             darktheme ? Colors.white : Colors.black,
                          //         fontSize: 16.0),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black,
                        ),
                        minLines: 5,
                        maxLines: 20,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.grey[200],
                          hintText: 'Details',
                          hintStyle: TextStyle(
                            color:
                                darktheme ? Colors.grey[200] : Colors.grey[600],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            eventDetail = value;
                          });
                        }),
                  ),
                  Center(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Colors.teal,
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          // print(_formkey.currentState.validate());
                          eventTime = '$eventTimeHour:$eventTimeMinute';
                          // print(eventTime);
                          // print(eventDetail);
                          if (eventDetail == null) {
                            setState(() {
                              eventDetail = 'No Details Available';
                              // print(eventDetail);
                            });
                          }
                          if (selectedTime != null)
                            addedevent =
                                '$eventTitle\r${selectedTime.format(context)}\r$eventDetail';
                          else {
                            selectedTime = TimeOfDay.now();
                            addedevent =
                                '$eventTitle\r${selectedTime.format(context)}\r$eventDetail';
                          }

                          if (eventTitle != null &&
                              int.parse(eventTimeHour) >= 0 &&
                              int.parse(eventTimeHour) <= 12 &&
                              int.parse(eventTimeMinute) >= 0 &&
                              int.parse(eventTimeHour) < 60) {
                            if (_controller.selectedDay.isUtc == true) {
                              if (_dateEvents[_controller.selectedDay] !=
                                  null) {
                                _dateEvents[_controller.selectedDay]
                                    .add(addedevent);
                              } else {
                                _dateEvents[_controller.selectedDay] = [
                                  addedevent
                                ];
                              }
                              Navigator.pop(context);
                              prefs.setString("events",
                                  json.encode(encodeMap(_dateEvents)));
                              print('');
                              // print(prefs.getString("events"));
                              setState(() {
                                addedString = '';
                                _selectedEvents =
                                    _dateEvents[_controller.selectedDay];
                                eventTimeHour = '12';
                                eventTimeMinute = '00';
                                addEvent(
                                    addedevent,
                                    _controller.selectedDay.toString(),
                                    _selectedEvents);
                                eventTitle = null;
                                eventTime = null;
                                eventDetail = null;
                              });
                            } else {
                              if (_dateEvents[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          17,
                                          30)
                                      .toUtc()] !=
                                  null) {
                                _dateEvents[DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                            17,
                                            30)
                                        .toUtc()]
                                    .add(addedevent);
                              } else {
                                _dateEvents[DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        17,
                                        30)
                                    .toUtc()] = [addedevent];
                              }
                              Navigator.pop(context);
                              prefs.setString("events",
                                  json.encode(encodeMap(_dateEvents)));

                              // print(prefs.getString("events"));
                              setState(() {
                                addedString = '';
                                _selectedEvents = _dateEvents[DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        17,
                                        30)
                                    .toUtc()];
                                eventTimeHour = '12';
                                eventTimeMinute = '00';
                                addEvent(
                                    addedevent,
                                    DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                            17,
                                            30)
                                        .toUtc()
                                        .toString(),
                                    _selectedEvents);
                                eventTitle = null;
                                eventTime = null;
                                eventDetail = null;
                              });
                            }
                          }
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showMessagePage() {
    if (isGetChannelNames == true) {
      return TabBarView(
          controller: _tabcontroller,
          children: channelnames.map((e) {
            return Messages(e, channelnames);
          }).toList());
    } else
      return Center(child: CircularProgressIndicator());
  }

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
}

class ShowEventDetails extends StatefulWidget {
  final String event;
  ShowEventDetails(this.event);
  @override
  _ShowEventDetailsState createState() => _ShowEventDetailsState(event);
}

class _ShowEventDetailsState extends State<ShowEventDetails> {
  final String event;
  _ShowEventDetailsState(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        title: Text(
          event.substring(0, event.indexOf('\r')),
          style: TextStyle(
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              event.substring(event.indexOf('\r'), event.lastIndexOf('\r')),
              style: TextStyle(
                fontSize: 20.0,
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: darktheme ? Colors.white : Colors.grey),
            ),
            Text(
              event.substring(event.lastIndexOf('\r')) == ' null'
                  ? 'No Details Available'
                  : event.substring(event.lastIndexOf('\r')),
              style: TextStyle(
                fontSize: 20.0,
                color: darktheme ? Colors.white : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
