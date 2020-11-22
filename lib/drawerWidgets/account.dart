import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:manipalleaks/authentication/auth.dart';
import 'package:manipalleaks/authentication/sign_in.dart';
import 'package:manipalleaks/drawerWidgets/selectImage.dart';
import 'package:manipalleaks/drawerWidgets/settings.dart';
import 'package:manipalleaks/main.dart';
import 'package:manipalleaks/authentication/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences prefs;
  var isuserDetailsLoaded = false;
  var isuserProfileLoaded = false;
  final AuthService _auth = AuthService();
  var year = ' ';
  var username = ' ';
  var email = ' ';
  var section = ' ';
  var regNo = ' ';
  var branch = ' ';
  var details = [];
  var detailname = [
    'Gender:',
    'Section:',
    'Year',
    'Registration Number:',
    'Branch:',
  ];
  var downloadUrl;
  var downloadAdresss;
  var gender;
  var emailverified;

  bool showTips = false;
  initState() {
    super.initState();
    getDetails();
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      showTips =
          prefs.getBool("showTips") == null ? true : prefs.getBool("showTips");
    });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  removeUserImage() async {
    final FirebaseUser user = await auth.currentUser();
    StorageReference reference =
        FirebaseStorage.instance.ref().child('${user.uid}');
    reference.delete();
  }

  getDetails() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      emailverified = user.isEmailVerified;
    });
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        username = value.data['name'];
        email = value.data['email'];
        year = value.data['year'];
        downloadUrl = value.data['imageUrl'];
        gender = value.data['gender'];
        isuserProfileLoaded = true;
        // print(downloadUrl);
        if (year == 'First Year') {
          year = '1st Year';
        } else if (year == "Second Year") {
          year = "2nd Year";
        } else if (year == "Third Year") {
          year = "3rd Year";
        } else if (year == "Fourth Year") {
          year = "4th Year";
        }
        section = value.data['section'];
        regNo = value.data['reg_no'];
        branch = value.data['branch'];
        details = [
          gender,
          section.toUpperCase(),
          year,
          regNo,
          branch,
        ];

        isuserDetailsLoaded = !isuserDetailsLoaded;
      });
    }).catchError((e) => print(e));
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        title: Text(
          'Account',
          style: TextStyle(
            fontSize: 18.0,
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit Details',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdditionalDetails(section, regNo),
                    ));
              })
        ],
      ),
      body: isuserDetailsLoaded
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  ListTile(
                    leading: !isuserProfileLoaded
                        ? Stack(
                            children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.account_circle,
                                  color:
                                      darktheme ? Colors.white : Colors.black,
                                  size: 30.0,
                                ),
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: darktheme
                                          ? Colors.grey[850]
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      scrollable: true,
                                      content: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text('Set Profile Picture',
                                                style: TextStyle(
                                                  color: darktheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                )),
                                            onTap: () {
                                              Navigator.push(
                                                      context,
                                                      _createRoute(SelectImage(
                                                          downloadUrl)))
                                                  .whenComplete(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              CircularProgressIndicator()
                            ],
                          )
                        : GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                _createRoute(
                                    UserProfile(downloadUrl, username, email))),
                            child: Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage: downloadUrl != null
                                    ? CachedNetworkImageProvider(downloadUrl)
                                    : AssetImage('assets/whitetest.png'),
                              ),
                            ),
                          ),
                    title: Text(
                      username,
                      style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black,
                          fontSize: height * 0.035),
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          email,
                          style: TextStyle(
                              color:
                                  darktheme ? Colors.white54 : Colors.grey[600],
                              fontSize: height * 0.020),
                        ),
                        !emailverified
                            ? IconButton(
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final FirebaseUser user =
                                      await auth.currentUser();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Email Not Verified',
                                        style: TextStyle(
                                          color: darktheme
                                              ? Colors.grey[200]
                                              : Colors.black,
                                        ),
                                      ),
                                      backgroundColor: darktheme
                                          ? Colors.grey[850]
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      content: Text(
                                        'Your email-id is not yet verified by our servers.\nTo verify your email-id, check your email inbox. If you don\'t find an email, click on VERIFY.\nIt may take upto a few minutes to verify your email-id.\nYou may have to login again in order to save changes.',
                                        style: TextStyle(
                                          color: darktheme
                                              ? Colors.grey[200]
                                              : Colors.black,
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              user.sendEmailVerification();
                                              Navigator.pop(context);
                                            },
                                            child: Text('VERIFY')),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('BACK'))
                                      ],
                                    ),
                                  );
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.verified_user,
                                    color: Colors.green),
                                onPressed: () {
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
                                            title: Text(
                                              'Email Verified',
                                              style: TextStyle(
                                                color: darktheme
                                                    ? Colors.grey[200]
                                                    : Colors.black,
                                              ),
                                            ),
                                            content: Text(
                                              'Your email id is verified by our servers',
                                              style: TextStyle(
                                                color: darktheme
                                                    ? Colors.grey[200]
                                                    : Colors.black,
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('OK'))
                                            ],
                                          ));
                                }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...details.map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '     ${detailname[details.indexOf(e)]}',
                                  style: TextStyle(
                                      color: darktheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.0),
                                ),
                              ),
                              Card(
                                color:
                                    darktheme ? Colors.grey[850] : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: ListTile(
                                  title: Text(
                                    e,
                                    style: TextStyle(
                                      color: darktheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ListTile(
                        title: Text(
                          'Show Tips',
                          style: TextStyle(
                              color: darktheme ? Colors.white : Colors.black),
                        ),
                        leading:
                            Icon(Icons.lightbulb_outline, color: Colors.yellow),
                        trailing: Switch(
                            value: showTips,
                            onChanged: (value) {
                              setState(() {
                                showTips = value;
                                prefs.setBool("showTips", showTips);
                              });
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ListTile(
                        title: Text(
                          'Sign Out',
                          style: TextStyle(
                              color: darktheme ? Colors.white : Colors.black),
                        ),
                        leading: Icon(Icons.power_settings_new,
                            color: darktheme ? Colors.white : Colors.black),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor: darktheme
                                        ? Colors.grey[850]
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
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
                                                (Route<dynamic> route) =>
                                                    false);
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: darktheme ? Colors.grey[800] : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ListTile(
                        title: Text(
                          'Delete Your Account',
                          style: TextStyle(
                              color: darktheme ? Colors.red[400] : Colors.red),
                        ),
                        leading: Icon(Icons.delete,
                            color: darktheme ? Colors.red[400] : Colors.red),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  darktheme ? Colors.grey[850] : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              title: Text(
                                "Do You Want To Delete This Account ?",
                                style: TextStyle(color: Colors.red),
                              ),
                              content: Text(
                                "Deleting this account will result in the deletion of all the data we have stored for your account including saved event data and configuration settings.\nAre you sure you want to continue?",
                                style: TextStyle(
                                  color: darktheme
                                      ? Colors.grey[200]
                                      : Colors.black,
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          _createRoute(ConfirmUserDetails()));
                                    },
                                    child: Text('YES')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('NO')),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    'Are you a CR or a student club represetative? Contact:',
                    style: TextStyle(
                        color: darktheme ? Colors.white30 : Colors.black38,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Abhinav Agrawal: ",
                        style: TextStyle(
                            color: darktheme ? Colors.white30 : Colors.black38,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        child: Text(
                          '8169809401',
                          style: TextStyle(
                              color:
                                  darktheme ? Colors.white30 : Colors.black38,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () => _launchURL('tel:8169809401'),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Shuvam Mandal: ",
                  //       style: TextStyle(
                  //           color: darktheme ? Colors.white30 : Colors.black38,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //     GestureDetector(
                  //       child: Text(
                  //         '9082268036',
                  //         style: TextStyle(
                  //             color:
                  //                 darktheme ? Colors.white30 : Colors.black38,
                  //             fontStyle: FontStyle.italic,
                  //             decoration: TextDecoration.underline),
                  //       ),
                  //       onTap: () => _launchURL('tel:9082268036'),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class UserProfile extends StatefulWidget {
  UserProfile(this.downloadUrl, this.username, this.email);
  final downloadUrl;
  final username;
  final email;
  @override
  _UserProfileState createState() =>
      _UserProfileState(downloadUrl, username, email);
}

class _UserProfileState extends State<UserProfile> {
  var downloadUrl;
  var username;
  var email;
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

  _UserProfileState(this.downloadUrl, this.username, this.email);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
        title: Text(
          'Account',
          style: TextStyle(
            fontSize: 18.0,
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Hero(
                tag: 'profile',
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 150.0,
                      backgroundImage: CachedNetworkImageProvider(downloadUrl),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 1,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(_createRoute(SelectImage(downloadUrl))),
                          child: Container(
                            child: CircleAvatar(
                              radius: width * 0.08,
                              child: Icon(Icons.add),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  size: height * 0.07,
                  color: darktheme ? Colors.white : Colors.black,
                ),
                title: Text(
                  username,
                  style: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
                      fontSize: height * 0.04),
                ),
                subtitle: Text(
                  email,
                  style: TextStyle(
                      color: darktheme ? Colors.white54 : Colors.black,
                      fontSize: height * 0.022),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
