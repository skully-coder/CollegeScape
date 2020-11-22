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
import 'package:url_launcher/url_launcher.dart';

class MarketPlaceMessages extends StatefulWidget {
  final marketPlaceService;
  MarketPlaceMessages(this.marketPlaceService);
  @override
  _MarketPlaceMessagesState createState() =>
      _MarketPlaceMessagesState(marketPlaceService);
}

class _MarketPlaceMessagesState extends State<MarketPlaceMessages>
    with AutomaticKeepAliveClientMixin {
  var marketPlaceService;
  List messages;
  var recievedMessages;
  List revmessages;

  var uname;

  var isAdminL1;
  _MarketPlaceMessagesState(this.marketPlaceService);

  @override
  void initState() {
    super.initState();
    // print(marketPlaceService);
    getCurrentUserName();
    getMessageList();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  getMessageList() async {
    await Firestore.instance
        .collection('/services')
        .document('Market Place')
        .collection('$marketPlaceService')
        .document('messages')
        .get()
        .then((value) {
      setState(() {
        messages = value.data['messages'];
        recievedMessages = true;
        // print(messages);
        revmessages = reverseMessages();
        // print(revmessages);
      });
    }).catchError((e) => print(e));
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '👇 Wanna sell something? Post 👇',
                      style: GoogleFonts.montserrat(
                          fontSize: 17.0,
                          color:
                              darktheme ? Colors.grey[100] : Colors.grey[900]),
                    ),
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
                  SizedBox(
                    height: 5.0,
                  ),
                  ...revmessages.map((e) => Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
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
                                  constraints:
                                      BoxConstraints(maxWidth: width * 0.75),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      onPressed: () {
                        if (marketPlaceService == 'Calculators') {
                          Navigator.push(
                                  context,
                                  _createRoute(MarketPlaceAddMessage(
                                      marketPlaceService,
                                      'Calculator Model',
                                      'You can specify if the calculator is used or not')))
                              .whenComplete(() => getMessageList());
                        } else if (marketPlaceService == 'Uniforms') {
                          Navigator.push(
                                  context,
                                  _createRoute(MarketPlaceAddMessage(
                                      marketPlaceService,
                                      'Uniform Size',
                                      'You can specify if the uniform is for men or women')))
                              .whenComplete(() => getMessageList());
                        } else if (marketPlaceService == 'Books') {
                          Navigator.push(
                                  context,
                                  _createRoute(MarketPlaceAddMessage(
                                      marketPlaceService,
                                      'Book Name',
                                      'You can specify the book condition')))
                              .whenComplete(() => getMessageList());
                        } else if (marketPlaceService == 'Miscellaneous') {
                          Navigator.push(
                                  context,
                                  _createRoute(MarketPlaceAddMessage(
                                      marketPlaceService,
                                      'Item Name',
                                      'Describe the item')))
                              .whenComplete(() => getMessageList());
                        }
                      },
                      child: Text(
                        'Sell',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      animationDuration: Duration(milliseconds: 200),
                      elevation: 6.0,
                      color: Colors.teal),
                ),
              ),
              SizedBox(
                height: height * 0.01,
                child: Container(
                  color: darktheme ? Colors.grey[900] : Colors.grey[200],
                ),
              )
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
                        '👇 Wanna sell something? Post 👇',
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
                            color: darktheme ? Colors.white70 : Colors.black38,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // RaisedButton(
                  //   onPressed: () async {
                  //     revmessages = ['abc'];
                  //     messages = revmessages.reversed.toList();
                  //     await Firestore.instance
                  //         .collection('/services')
                  //         .document('Market Place')
                  //         .collection('$marketPlaceService')
                  //         .document('messages')
                  //         .setData({'messages': messages}, merge: true).then(
                  //             (value) {
                  //       print('Data Set');
                  //       getMessageList();
                  //     }).catchError((e) => print(e));
                  //   },
                  // ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
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
        title: 'Share',
        text: e.toString().substring(e.toString().indexOf('\n')),
        chooserTitle: 'Share To:');
  }

  showOptions(var e) {
    print((e.toString().substring(0, e.toString().indexOf('\n')).trim()));
    if (e.toString().substring(0, e.toString().indexOf('\n')).trim() == uname ||
        isAdminL1 == true)
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
              await Firestore.instance
                  .collection('/services')
                  .document('Market Place')
                  .collection('$marketPlaceService')
                  .document('messages')
                  .setData({
                'messages': messages,
              }, merge: true).then((value) {
                // print('Message Deleted');
                getMessageList();
              }).catchError((e) => print(e));

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    else
      return Column(
        children: [
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
        ],
      );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUserName() async {
    final FirebaseUser user = await auth.currentUser();

    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      uname = value.data['name'];
      isAdminL1 = value.data['adminL1'];
    }).catchError((e) => print(e));
    // print(uname);

    return uname;
  }
}

class MarketPlaceAddMessage extends StatefulWidget {
  final String marketPlaceService;
  final String serviceParameter;
  final String itemhint;
  MarketPlaceAddMessage(
      this.marketPlaceService, this.serviceParameter, this.itemhint);

  @override
  _MarketPlaceAddMessageState createState() => _MarketPlaceAddMessageState(
      marketPlaceService, serviceParameter, itemhint);
}

class _MarketPlaceAddMessageState extends State<MarketPlaceAddMessage> {
  String marketPlaceService;
  String serviceParameter;
  String itemhint;
  final _formkey = GlobalKey<FormState>();
  String serviceParametertitle;
  String itemPrice;
  String phone;
  String itemDesc;
  var uname;
  var uemail;

  List messages;
  _MarketPlaceAddMessageState(
      this.marketPlaceService, this.serviceParameter, this.itemhint);
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      uname = value.data['name'];
      uemail = value.data['email'];
    }).catchError((e) => print(e));
    // print(uname);

    return uname;
  }

  reverseMessages() {
    var revmessage = messages.reversed.toList();
    return revmessage;
  }

  List revmessages;
  getMessageList() async {
    await Firestore.instance
        .collection('/services')
        .document('Market Place')
        .collection('$marketPlaceService')
        .document('messages')
        .get()
        .then((value) {
      messages = value.data['messages'];
      // print(messages);
      if (mounted)
        setState(() {
          revmessages = reverseMessages();
          // print(revmessages);
        });
    }).catchError((e) => print(e));
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        title: Text(
          marketPlaceService,
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
          child: Center(
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
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.white,
                          filled: true,
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
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
                          hintText: serviceParameter,
                          hintStyle: TextStyle(
                              color:
                                  darktheme ? Colors.white : Colors.grey[600]),
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        validator: (val) => val == null || val.length == 0
                            ? 'Should Not Be Empty'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            print(val);
                            serviceParametertitle = val;
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
                          color: darktheme ? Colors.white : Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.white,
                          filled: true,
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
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
                          hintText: 'Item Price',
                          hintStyle: TextStyle(
                              color:
                                  darktheme ? Colors.white : Colors.grey[600]),
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        validator: (val) => val == null || val.length == 0
                            ? 'Should Not Be Empty'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            itemPrice = val;
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
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.white,
                          filled: true,
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
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
                          hintText: 'Contact Number',
                          hintStyle: TextStyle(
                              color:
                                  darktheme ? Colors.white : Colors.grey[600]),
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        validator: (val) => val.length != 10 || val == null
                            ? 'Should Be At Least 10 digits'
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
                        maxLines: 8,
                        minLines: 6,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.white,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          fillColor:
                              darktheme ? Colors.grey[800] : Colors.white,
                          filled: true,
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                              color:
                                  darktheme ? Colors.grey[800] : Colors.white,
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
                          hintText: 'Item Description',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                              color: darktheme
                                  ? Colors.white54
                                  : Colors.grey[600]),
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        validator: (val) => val == null || val.length == 0
                            ? 'Should Not Be Empty'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            itemDesc = val;
                          });
                        },
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.teal,
                    elevation: 0.0,
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        var text =
                            '$uname\n$serviceParameter: $serviceParametertitle\nItem Price: Rs.$itemPrice\nItem Description: $itemDesc\nEmail : $uemail\nContact: $phone\n';

                        revmessages.add(text);
                        messages = revmessages.reversed.toList();
                        await Firestore.instance
                            .collection('/services')
                            .document('Market Place')
                            .collection(marketPlaceService)
                            .document('messages')
                            .setData({'messages': messages}, merge: true)
                            .then((value) => print(text))
                            .catchError((e) => print(e));
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Sell',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
