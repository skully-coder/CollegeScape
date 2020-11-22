import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

bool darktheme = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollegeScape',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
