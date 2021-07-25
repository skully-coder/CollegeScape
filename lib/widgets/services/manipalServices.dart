import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manipalleaks/main.dart';
import 'package:manipalleaks/widgets/services/cab_sharing.dart';
import 'package:manipalleaks/widgets/services/lost_found.dart';
import 'package:manipalleaks/widgets/services/market_place.dart';
import 'package:manipalleaks/widgets/services/room_sharing.dart';
import 'package:url_launcher/url_launcher.dart';

class ManipalServices extends StatefulWidget {
  final String servicename;
  ManipalServices(this.servicename);
  @override
  _ManipalServicesState createState() => _ManipalServicesState(servicename);
}

class _ManipalServicesState extends State<ManipalServices>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TabController _marketTabController;
  var isAdmin = false;
  var messages = [];
  var revmessages = [];
  var username = ' ';
  var text = '';
  var recievedMessages = false;
  var servicename;
  var gender;
  var marketPlaceTabs = ['Calculators', 'Uniforms', 'Books', 'Miscellaneous'];
  var selectedTabName = 'Calculators';

  var isAdminL1;
  _ManipalServicesState(this.servicename);
  void initState() {
    super.initState();
    getAdminFlag().whenComplete(() => getMessageList());
    // print(servicename);
    _marketTabController = TabController(length: 4, vsync: this);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  Future getAdminFlag() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          isAdminL1 = value.data['adminL1'];
          username = value.data['name'];
          gender = value.data['gender'];
          // print(username);
          // print(isAdmin);
          // print(gender);
        });
    }).catchError((e) => print(e));
  }

  getMessageList() async {
    if (servicename == 'Room Sharing') {
      // print('Room Sharing');
      // print(gender);
      await Firestore.instance
          .collection('/services')
          .document('Room Sharing')
          .collection('$gender')
          .document('messages')
          .get()
          .then((value) {
        messages = value.data['messages'];
        //print(messages);
        if (mounted)
          setState(() {
            recievedMessages = true;
            revmessages = reverseMessages();
            // print(revmessages);
          });
      }).catchError((e) => print(e));
    } else if (servicename == 'Cab Sharing') {
      await Firestore.instance
          .collection('/services')
          .document('$servicename')
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
    } else if (servicename == 'Lost & Found') {
      await Firestore.instance
          .collection('/services')
          .document('$servicename')
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
    }
    return messages;
  }

  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (recievedMessages == true) {
      return Scaffold(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: darktheme ? Colors.white : Colors.grey[800],
          ),
          backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
          title: Text(
            servicename,
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  getMessageList();
                })
          ],
          bottom: servicename == 'Market Place'
              ? TabBar(
                  labelColor: darktheme ? Colors.white : Colors.black,
                  tabs: marketPlaceTabs
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                  controller: _marketTabController,
                )
              : null,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (servicename == 'Room Sharing')
              Navigator.push(context, _createRoute(RoomSharing()))
                  .whenComplete(() => getMessageList());
            else if (servicename == 'Cab Sharing') {
              Navigator.push(context, _createRoute(CabSharing()))
                  .whenComplete(() => getMessageList());
            } else if (servicename == 'Lost & Found') {
              Navigator.push(context, _createRoute(LostAndFound()))
                  .whenComplete(() => getMessageList());
            }
            setState(() {
              recievedMessages = true;
            });
          },
          child: Icon(Icons.add),
          tooltip: 'Add Enquiry',
        ),
        // body: Stack(
        //   children: [
        //     SingleChildScrollView(
        //       scrollDirection: Axis.vertical,
        //       reverse: true,
        //       dragStartBehavior: DragStartBehavior.down,
        //       child: Padding(
        //         padding: const EdgeInsets.all(12.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.all(12.0),
        //               child: Text(
        //                 '# Welcome To Start of $servicename',
        //                 style: TextStyle(
        //                     color: darktheme ? Colors.white : Colors.black,
        //                     fontSize: 17.0),
        //               ),
        //             ),
        //             Divider(
        //               color: darktheme ? Colors.white : Colors.white,
        //             ),
        //             ...revmessages.map((e) => Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     GestureDetector(
        //                       onLongPress: () async {
        //                         await showDialog(
        //                           context: context,
        //                           builder: (context) => AlertDialog(
        //                             scrollable: true,
        //                             content: showOptions(e),
        //                           ),
        //                         );
        //                       },
        //                       child: Card(
        //                         margin:
        //                             EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 4.0),
        //                         elevation: 4.0,
        //                         shape: RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.only(
        //                                 topLeft: Radius.circular(15.0),
        //                                 topRight: Radius.circular(15.0),
        //                                 bottomRight: Radius.circular(15.0))),
        //                         child: Container(
        //                             decoration: BoxDecoration(
        //                                 color: darktheme
        //                                     ? Colors.blueGrey
        //                                     : Colors.white,
        //                                 borderRadius: BorderRadius.only(
        //                                     topLeft: Radius.circular(15.0),
        //                                     topRight: Radius.circular(15.0),
        //                                     bottomRight:
        //                                         Radius.circular(15.0))),
        //                             padding: EdgeInsets.all(12.0),
        //                             child: Column(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 RichText(
        //                                     text: TextSpan(
        //                                         text: e.toString().substring(0,
        //                                             e.toString().indexOf('\n')),
        //                                         style: TextStyle(
        //                                             color: darktheme
        //                                                 ? Colors.white
        //                                                 : Colors.black,
        //                                             fontSize: 17.0,
        //                                             fontWeight:
        //                                                 FontWeight.bold))),
        //                                 Linkify(
        //                                   onOpen: (link) {
        //                                     _launchURL('${link.url}');
        //                                   },
        //                                   text: e.toString().substring(
        //                                       e.toString().indexOf('\n')),
        //                                   style: TextStyle(
        //                                       fontSize: 15.0,
        //                                       color: darktheme
        //                                           ? Colors.white
        //                                           : Colors.black),
        //                                   linkStyle:
        //                                       TextStyle(color: Colors.blue),
        //                                 ),
        //                               ],
        //                             )),
        //                       ),
        //                     ),
        //                     CircleAvatar(
        //                       backgroundImage:
        //                           AssetImage('assets/profile.jpeg'),
        //                     ),
        //                   ],
        //                 )),
        //             SizedBox(
        //               height: height * 0.08,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         SizedBox(
        //           height: height * 0.065,
        //           child: Container(
        //             color: darktheme
        //                 ? Colors.grey[900]
        //                 : Color.fromRGBO(77, 214, 214, 1),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         SizedBox(
        //           height: height * 0.01,
        //           child: Container(
        //             color: darktheme
        //                 ? Colors.grey[900]
        //                 : Color.fromRGBO(77, 214, 214, 1),
        //           ),
        //         )
        //       ],
        //     ),
        //   ],
        // ),
        body: selectBodyTab(height, width),
      );
    } else
      return Scaffold(
        floatingActionButton: servicename == 'Room Sharing' ||
                servicename == 'Cab Sharing' ||
                servicename == 'Lost & Found'
            ? FloatingActionButton(
                onPressed: () {
                  if (servicename == 'Room Sharing')
                    Navigator.push(context, _createRoute(RoomSharing()))
                        .whenComplete(() => getMessageList());
                  else if (servicename == 'Cab Sharing') {
                    Navigator.push(context, _createRoute(CabSharing()))
                        .whenComplete(() => getMessageList());
                  } else if (servicename == 'Lost & Found') {
                    Navigator.push(context, _createRoute(LostAndFound()))
                        .whenComplete(() => getMessageList());
                  }
                  setState(() {
                    recievedMessages = true;
                  });
                },
                child: Icon(Icons.add),
                tooltip: 'Add Enquiry',
              )
            : null,
        backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: darktheme ? Colors.white : Colors.grey[800],
          ),
          backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
          bottom: servicename == 'Market Place'
              ? TabBar(
                  labelStyle:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  labelPadding: EdgeInsets.all(0.0),
                  labelColor: darktheme ? Colors.white : Colors.black,
                  tabs: marketPlaceTabs
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                  controller: _marketTabController,
                )
              : null,
          title: Text(
            servicename,
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        // body: Stack(
        //   children: [
        //     Positioned(
        //       child: CircularProgressIndicator(),
        //       bottom: height * 0.45,
        //       left: width * 0.45,
        //     ),
        //     Center(
        //         child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(12.0),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.all(12.0),
        //                 child: Text(
        //                   '# Welcome To Start of $servicename',
        //                   style: TextStyle(
        //                       color: darktheme ? Colors.white : Colors.black,
        //                       fontSize: 17.0),
        //                 ),
        //               ),
        //               Divider(
        //                 color: darktheme ? Colors.white : Colors.white,
        //               ),
        //             ],
        //           ),
        //         )
        //       ],
        //     )),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         SizedBox(height: height * 0.01),
        //       ],
        //     )
        //   ],
        // ),
        body: selectBodyTab(height, width),
      );
  }

  selectBodyTab(var height, var width) {
    switch (servicename) {
      case 'Room Sharing':
      case 'Cab Sharing':
      case 'Lost & Found':
        if (recievedMessages == true) {
          return Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                dragStartBehavior: DragStartBehavior.down,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          servicename == 'Room Sharing'
                              ? '👇 Looking for a roomie? Post👇'
                              : servicename == 'Cab Sharing'
                                  ? '👇 Looking to share a cab? Post👇'
                                  : servicename == 'Lost & Found'
                                      ? '👇 Lost something in campus? Post👇'
                                      : 'Hey there',
                          style: GoogleFonts.montserrat(
                              fontSize: 17.0,
                              color: darktheme
                                  ? Colors.grey[100]
                                  : Colors.grey[900]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Long press message for more options',
                          style: TextStyle(
                              color:
                                  darktheme ? Colors.white70 : Colors.black38,
                              fontSize: 12.0),
                        ),
                      ),
                      Divider(
                          color: darktheme ? Colors.grey : Colors.grey[600],
                          thickness: 2.0,
                          height: 10),
                      SizedBox(height: 5.0),
                      ...revmessages.map((e) => Container(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/userprofile.png'),
                                  radius: 15.0,
                                ),
                                GestureDetector(
                                  onLongPress: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        backgroundColor: darktheme
                                            ? Colors.grey[850]
                                            : Colors.white,
                                        scrollable: true,
                                        content: showOptions(e),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      constraints: BoxConstraints.loose(
                                          Size.fromWidth(width * 0.70)),
                                      margin: EdgeInsets.fromLTRB(
                                          6.0, 0.0, 0.0, 0.0),
                                      decoration: BoxDecoration(
                                          color: darktheme
                                              ? Colors.grey[800]
                                              : Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: darktheme
                                                    ? Colors.transparent
                                                    : Colors.grey,
                                                blurRadius: 0.1,
                                                offset:
                                                    Offset.fromDirection(-5.0)),
                                          ],
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              topRight: Radius.circular(5.0),
                                              bottomRight:
                                                  Radius.circular(5.0))),
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              softWrap: true,
                                              text: TextSpan(
                                                  text: e.toString().substring(
                                                      0,
                                                      e
                                                          .toString()
                                                          .indexOf('\n')),
                                                  style: TextStyle(
                                                      color: darktheme
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Linkify(
                                            onOpen: (link) {
                                              _launchURL('${link.url}');
                                            },
                                            text: e.toString().substring(
                                                e.toString().indexOf('\n')),
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: darktheme
                                                    ? Colors.white
                                                    : Colors.black),
                                            linkStyle: TextStyle(
                                                color: darktheme
                                                    ? Colors.lightBlue
                                                    : Colors.blue),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: height * 0.08,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: height * 0.065,
                    child: Container(
                      color: darktheme ? Colors.grey[900] : Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              Positioned(
                child: CircularProgressIndicator(),
                bottom: height * 0.45,
                left: width * 0.45,
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            servicename == 'Room Sharing'
                                ? '👇 Looking for a roomie? Post👇'
                                : servicename == 'Cab Sharing'
                                    ? '👇 Looking to share a cab? Post👇'
                                    : servicename == 'Lost & Found'
                                        ? '👇 Lost something in campus? Post👇'
                                        : 'Hey there',
                            style: GoogleFonts.montserrat(
                                fontSize: 17.0,
                                color: darktheme
                                    ? Colors.grey[100]
                                    : Colors.grey[900]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Long press message for more options',
                            style: TextStyle(
                                color:
                                    darktheme ? Colors.white70 : Colors.black38,
                                fontSize: 12.0),
                          ),
                        ),
                        Divider(
                          color: darktheme ? Colors.grey : Colors.grey[600],
                          thickness: 2.0,
                          height: 10.0,
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ],
          );
        }
        break;
      case 'Market Place':
        return TabBarView(
          controller: _marketTabController,
          children: marketPlaceTabs != null
              ? marketPlaceTabs.map((e) {
                  // print(e);
                  return MarketPlaceMessages(e);
                }).toList()
              : [],
        );
      default:
        return Container();
        break;
    }
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

  Future<void> share(var e) async {
    await FlutterShare.share(
        title: 'Share', text: e, chooserTitle: 'Share To:');
  }

  showOptions(var e) {
    if (e.toString().substring(0, e.toString().indexOf('\n')).trim() !=
        username) {
      return Column(
        children: [
          ListTile(
            title: Text(
              'Make A Call',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              Icons.phone,
              color: Colors.grey,
            ),
            onTap: () {
              _launchURL(
                  'tel:${e.toString().substring(e.toString().lastIndexOf(':'))}');
            },
          ),
          ListTile(
            title: Text(
              'WhatsApp',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              FontAwesome.whatsapp,
              color: Colors.grey,
            ),
            onTap: () {
              _launchURL(
                  'https://wa.me/91${e.toString().substring(e.toString().lastIndexOf(':'))}');
            },
          ),
          ListTile(
            title: Text(
              'Share',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              Icons.share,
              color: Colors.grey,
            ),
            onTap: () async {
              await share(e);
            },
          ),
          ListTile(
            title: Text(
              'Copy',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              Icons.content_copy,
              color: Colors.grey,
            ),
            onTap: () {
              Clipboard.setData(new ClipboardData(
                  text:
                      e.toString().substring(e.toString().indexOf('\n') + 1)));
              Navigator.pop(context);
            },
          ),
          isAdminL1 == true
              ? ListTile(
                  title: Text(
                    'Delete',
                    style: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
                    ),
                  ),
                  leading: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    messages.remove(e);
                    if (servicename == 'Room Sharing') {
                      await Firestore.instance
                          .collection('/services')
                          .document('$servicename')
                          .collection('$gender')
                          .document('messages')
                          .setData({
                        'messages': messages,
                      }, merge: true).then((value) {
                        // print('Message Deleted');
                        getMessageList();
                      }).catchError((e) => print(e));
                    } else if (servicename == 'Cab Sharing') {
                      await Firestore.instance
                          .collection('/services')
                          .document('$servicename')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        // print('Deleted');
                        getMessageList();
                      }).catchError((e) => print(e));
                    } else if (servicename == 'Lost & Found') {
                      await Firestore.instance
                          .collection('/services')
                          .document('$servicename')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        // print('Deleted');
                        getMessageList();
                      }).catchError((e) => print(e));
                    }
                    Navigator.of(context).pop();
                  },
                )
              : Offstage(),
        ],
      );
    } else {
      return Column(
        children: [
          ListTile(
            title: Text(
              'Share',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              Icons.share,
              color: Colors.grey,
            ),
            onTap: () async {
              await share(
                  e.toString().substring(e.toString().indexOf('\n') + 1));
            },
          ),
          ListTile(
            title: Text(
              'Copy',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              Icons.content_copy,
              color: Colors.grey,
            ),
            onTap: () {
              Clipboard.setData(new ClipboardData(
                  text:
                      e.toString().substring(e.toString().indexOf('\n') + 1)));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Delete',
              style: TextStyle(
                color: darktheme ? Colors.white : Colors.black,
              ),
            ),
            leading: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () async {
              messages.remove(e);
              if (servicename == 'Room Sharing') {
                await Firestore.instance
                    .collection('/services')
                    .document('$servicename')
                    .collection('$gender')
                    .document('messages')
                    .setData({
                  'messages': messages,
                }, merge: true).then((value) {
                  // print('Message Deleted');
                  getMessageList();
                }).catchError((e) => print(e));
              } else if (servicename == 'Cab Sharing') {
                await Firestore.instance
                    .collection('/services')
                    .document('$servicename')
                    .setData({'messages': messages}, merge: true).then((value) {
                  // print('Deleted');
                  getMessageList();
                }).catchError((e) => print(e));
              } else if (servicename == 'Lost & Found') {
                await Firestore.instance
                    .collection('/services')
                    .document('$servicename')
                    .setData({'messages': messages}, merge: true).then((value) {
                  // print('Deleted');
                  getMessageList();
                }).catchError((e) => print(e));
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}

// children: [
//                                         RichText(
//                                             text: TextSpan(
//                                                 text: e.toString().substring(0,
//                                                     e.toString().indexOf('\n')),
//                                                 style: TextStyle(
//                                                     color: darktheme
//                                                         ? Colors.white
//                                                         : Colors.black,
//                                                     fontSize: 17.0,
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         Linkify(
//                                           onOpen: (link) {
//                                             _launchURL('${link.url}');
//                                           },
//                                           text: e.toString().substring(
//                                               e.toString().indexOf('\n')),
//                                           style: TextStyle(
//                                               fontSize: 15.0,
//                                               color: darktheme
//                                                   ? Colors.white
//                                                   : Colors.black),
//                                           linkStyle: TextStyle(
//                                               color: darktheme
//                                                   ? Colors.lightBlue
//                                                   : Colors.blue),
//                                         ),
//                                       ],
