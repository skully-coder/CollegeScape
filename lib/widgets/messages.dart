import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manipalleaks/main.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Messages extends StatefulWidget {
  Messages(this.channelname, this.channels);
  final String channelname;
  final List channels;
  @override
  _MessagesState createState() => _MessagesState(channelname, channels);
}

class _MessagesState extends State<Messages>
    with AutomaticKeepAliveClientMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _controller = TextEditingController();
  var isAdmin = false;
  var messages = [];
  var revmessages = [];
  var username = ' ';
  var text = '';
  var recievedMessages = false;
  var channelname;
  List<String> channels;
  var imageUrl;

  var isAdminL1;

  var isAdminL2;

  var isAdminL3;

  var isAdminClub;
  _MessagesState(this.channelname, this.channels);
  void initState() {
    super.initState();
    getMessageList();
    getAdminFlag();
    print(channels);
  }

  @override
  bool get wantKeepAlive => true;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  getAdminFlag() async {
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          isAdminL1 = value.data['adminL1'];
          isAdminL2 = value.data['adminL2'];
          isAdminL3 = value.data['adminL3'];
          isAdminClub = value.data['adminClub'];
          username = value.data['name'];
          imageUrl = value.data['imageUrl'];
          print(imageUrl);
          // print(username);
          // print(isAdmin);
        });
    }).catchError((e) => print(e));
  }

  getMessageList() async {
    await Firestore.instance
        .collection('/updates')
        .document('$channelname')
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

  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (recievedMessages == true) {
      return Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            dragStartBehavior: DragStartBehavior.down,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        channels.indexOf(channelname) == 0
                            ? '👇Updates from Student Council 👇'
                            : channels.indexOf(channelname) == 1
                                ? '👇Updates from your CR 👇'
                                : channels.indexOf(channelname) == 2
                                    ? '👇Club Promotions 👇'
                                    : "Hey There",
                        style: GoogleFonts.montserrat(
                            fontSize: 17.0,
                            color: darktheme
                                ? Colors.grey[100]
                                : Colors.grey[900])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Long press message for more options',
                      style: TextStyle(
                          color: darktheme ? Colors.white70 : Colors.black38,
                          fontSize: 12.0),
                    ),
                  ),
                  Divider(
                      color: darktheme ? Colors.grey : Colors.grey[600],
                      thickness: 2.0,
                      height: 10),
                  SizedBox(height: 5.0),
                  ...revmessages.map((e) => Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                e.toString().substring(
                                    e.toString().indexOf('\f') + 1,
                                    e.toString().lastIndexOf('\f')),
                              ),
                              // backgroundImage:
                              //     AssetImage('assets/userprofile.png'),
                              radius: 15.0,
                              onBackgroundImageError: (exception, stackTrace) =>
                                  AssetImage('assets/userprofile.png'),
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
                                      Size.fromWidth(width * 0.85)),
                                  margin:
                                      EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
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
                                            offset: Offset.fromDirection(-5.0)),
                                      ],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0))),
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              text: e.toString().substring(0,
                                                  e.toString().indexOf('\n')),
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
                                            e.toString().indexOf('\n'),
                                            e.toString().lastIndexOf('\n')),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              showTextForm(),
              SizedBox(
                height: height * 0.02,
              )
            ],
          ),
        ],
      );
    } else
      return Stack(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                      channels.indexOf(channelname) == 0
                          ? '👇Updates from Student Council 👇'
                          : channels.indexOf(channelname) == 1
                              ? '👇Updates from your CR 👇'
                              : channels.indexOf(channelname) == 2
                                  ? '👇Club Promotions 👇'
                                  : "Hey There",
                      style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color:
                              darktheme ? Colors.grey[100] : Colors.grey[900])),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Long press message for more options',
                    style: TextStyle(
                        color: darktheme ? Colors.white70 : Colors.black38,
                        fontSize: 12.0),
                  ),
                ),
                Divider(
                    color: darktheme ? Colors.grey : Colors.grey[600],
                    thickness: 2.0,
                    height: 10),
              ],
            ),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              showTextForm(),
              SizedBox(
                height: height * 0.01,
              )
            ],
          )
        ],
      );
  }

  showTextForm() {
    double width = MediaQuery.of(context).size.width;
    if (isAdminL1 == true) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: darktheme ? Colors.transparent : Colors.grey,
                  blurRadius: 0.1,
                  offset: Offset.fromDirection(-5.0)),
            ],
          ),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            minLines: 1,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Message',
              hintStyle: TextStyle(
                color: darktheme ? Colors.grey[200] : Colors.grey[600],
              ),
              filled: true,
              fillColor: darktheme ? Colors.grey[800] : Colors.white,
              suffixIcon: IconButton(
                  splashRadius: 5.0,
                  icon: Icon(Icons.send,
                      color: darktheme ? Colors.white : Colors.grey[600]),
                  onPressed: () async {
                    if (text != '') {
                      revmessages.add(
                          '$username \n$text \n\f$imageUrl\f_Brought to you with ❤️ by *ManipalLeaks*_');
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/updates')
                          .document('$channelname')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        print('Data Set');
                        if (mounted)
                          setState(() {
                            getMessageList();
                            _controller.clear();
                          });
                      }).catchError((e) => print(e));
                    }
                    print(text);
                  }),
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
              // labelText: 'Message',
              // labelStyle: TextStyle(
              //   color: darktheme ? Colors.white : Colors.black,
              // ),
              contentPadding: EdgeInsets.all(width * 0.03),
            ),
            onChanged: (val) {
              if (mounted)
                setState(() {
                  text = val;
                });
            },
          ),
        ),
      );
    } else if (isAdminL2 == true && channels.indexOf(channelname) == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: darktheme ? Colors.transparent : Colors.grey,
                  blurRadius: 0.1,
                  offset: Offset.fromDirection(-5.0)),
            ],
          ),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            minLines: 1,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Message',
              hintStyle: TextStyle(
                color: darktheme ? Colors.grey[200] : Colors.grey[600],
              ),
              filled: true,
              fillColor: darktheme ? Colors.grey[800] : Colors.white,
              suffixIcon: IconButton(
                  icon: Icon(Icons.send,
                      color: darktheme ? Colors.white : Colors.grey[600]),
                  onPressed: () async {
                    if (text != '') {
                      revmessages.add(
                          '$username \n$text \n\f$imageUrl\f_Brought to you with ❤️ by *ManipalLeaks*_');
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/updates')
                          .document('$channelname')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        print('Data Set');
                        if (mounted)
                          setState(() {
                            getMessageList();
                            _controller.clear();
                          });
                      }).catchError((e) => print(e));
                    }
                  }),
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
              // labelText: 'Message',
              // labelStyle: TextStyle(
              //   color: darktheme ? Colors.white : Colors.black,
              // ),
              contentPadding: EdgeInsets.all(width * 0.03),
            ),
            onChanged: (val) {
              if (mounted)
                setState(() {
                  text = val;
                });
            },
          ),
        ),
      );
    } else if (isAdminL3 == true && channels.indexOf(channelname) == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: darktheme ? Colors.transparent : Colors.grey,
                  blurRadius: 0.1,
                  offset: Offset.fromDirection(-5.0)),
            ],
          ),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            minLines: 1,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Message',
              hintStyle: TextStyle(
                color: darktheme ? Colors.grey[200] : Colors.grey[600],
              ),
              filled: true,
              fillColor: darktheme ? Colors.grey[800] : Colors.white,
              suffixIcon: IconButton(
                  splashRadius: 5.0,
                  icon: Icon(Icons.send,
                      color: darktheme ? Colors.white : Colors.grey[600]),
                  onPressed: () async {
                    if (text != '') {
                      revmessages.add(
                          '$username \n$text \n\f$imageUrl\f_Brought to you with ❤️ by *ManipalLeaks*_');
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/updates')
                          .document('$channelname')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        print('Data Set');
                        if (mounted)
                          setState(() {
                            getMessageList();
                            _controller.clear();
                          });
                      }).catchError((e) => print(e));
                    }
                  }),
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
              // labelText: 'Message',
              // labelStyle: TextStyle(
              //   color: darktheme ? Colors.white : Colors.black,
              // ),
              contentPadding: EdgeInsets.all(width * 0.03),
            ),
            onChanged: (val) {
              if (mounted)
                setState(() {
                  text = val;
                });
            },
          ),
        ),
      );
    } else if (isAdminClub == true && channels.indexOf(channelname) == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: darktheme ? Colors.transparent : Colors.grey,
                  blurRadius: 0.1,
                  offset: Offset.fromDirection(-5.0)),
            ],
          ),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            minLines: 1,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Message',
              hintStyle: TextStyle(
                color: darktheme ? Colors.grey[200] : Colors.grey[600],
              ),
              filled: true,
              fillColor: darktheme ? Colors.grey[800] : Colors.white,
              suffixIcon: IconButton(
                  splashRadius: 5.0,
                  icon: Icon(Icons.send,
                      color: darktheme ? Colors.white : Colors.grey[600]),
                  onPressed: () async {
                    if (text != '') {
                      revmessages.add(
                          '$username \n$text \n\f$imageUrl\f_Brought to you with ❤️ by *ManipalLeaks*_');
                      messages = revmessages.reversed.toList();
                      await Firestore.instance
                          .collection('/updates')
                          .document('$channelname')
                          .setData({'messages': messages}, merge: true).then(
                              (value) {
                        print('Data Set');
                        if (mounted)
                          setState(() {
                            getMessageList();
                            _controller.clear();
                          });
                      }).catchError((e) => print(e));
                    }
                  }),
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
              // labelText: 'Message',
              // labelStyle: TextStyle(
              //   color: darktheme ? Colors.white : Colors.black,
              // ),
              contentPadding: EdgeInsets.all(width * 0.03),
            ),
            onChanged: (val) {
              if (mounted)
                setState(() {
                  text = val;
                });
            },
          ),
        ),
      );
    }
    return Offstage();
  }

  Future<void> share(var e) async {
    await FlutterShare.share(
        title: 'Share',
        text: e.toString().substring(
                e.toString().indexOf('\n'), e.toString().lastIndexOf('\n')) +
            '\n' +
            e.toString().substring(e.toString().lastIndexOf('\f')),
        chooserTitle: 'Share To:');
  }

  showOptions(var e) {
    print(isAdminL1);
    if (isAdminL1 == true ||
        isAdminL2 == true && channels.indexOf(channelname) == 0) {
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
                text: e.toString().substring(e.toString().indexOf('\n'),
                        e.toString().lastIndexOf('\n')) +
                    '\n' +
                    e.toString().substring(e.toString().lastIndexOf('\f')),
              ));
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
              await Firestore.instance
                  .collection('/updates')
                  .document('$channelname')
                  .setData({
                'messages': messages,
              }, merge: true).then((value) {
                print('Message Deleted');
                getMessageList();
              }).catchError((e) => print(e));

              Navigator.of(context).pop();
            },
          ),
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
                text: e.toString().substring(e.toString().indexOf('\n'),
                        e.toString().lastIndexOf('\n')) +
                    '\n' +
                    e.toString().substring(e.toString().lastIndexOf('\f')),
              ));
              Navigator.pop(context);
            },
          ),
        ],
      );
    }
  }
}
