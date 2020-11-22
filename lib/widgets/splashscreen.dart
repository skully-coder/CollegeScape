import 'dart:math';

import 'package:flutter/material.dart';

import 'package:manipalleaks/widgets/homepage.dart';
import 'package:manipalleaks/authentication/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _checkSession().then((status) {
      if (status) {
        _navigate();
      }
    });
  }

  Future<bool> _checkSession() async {
    await Future.delayed(Duration(seconds: 1), () {});
    return true;
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

  void _navigate() async {
    final FirebaseUser user = await auth.currentUser();
    print(user == null);
    if (user == null) {
      Navigator.of(context)
          .pushAndRemoveUntil(_createRoute(SignIn()), (route) => false);
    } else {
      Navigator.of(context)
          .pushAndRemoveUntil(_createRoute(HomePage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    var randInt = random.nextInt(4);
    print(randInt);
    const iconname = [
      'assets/bluetest.png',
      'assets/firetest.png',
      'assets/leaks 7 (1).png',
      'assets/whitetest.png'
    ];
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 148, 180, 10),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/shuvam logo.png')
            // Shimmer.fromColors(
            //     child: Image.asset('assets/profile.jpeg'),
            //     baseColor: Colors.purple,
            //     highlightColor: Colors.purple[200])
          ],
        ),
      ),
    );
  }
}
