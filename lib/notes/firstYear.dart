import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class FirstYear extends StatelessWidget {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  final List<String> firstCourses = [
    "Engineering Physics",
    "Engineering Mathematics 1",
    "Engineering Mathematics 2",
    "Basic Mechanical Engineering",
    "Basic Electronics",
    "Mechanics of Solids",
    "English",
    "Engineering Chemistry",
    "Basic Electrical Technology",
    "Problem Solving Using Computers",
    "Biology for Engineers",
    "Environmental Studies",
    "Engineering Graphics 1",
    "Engineering Graphics 2",
    "Physics Lab",
    "Chemistry Lab",
    "PSUC Lab",
    "Workshop Practice"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
        appBar: AppBar(
          title: Text(
            "First Year", 
            style: TextStyle(
              color:darktheme ? Colors.white : Colors.black, 
            ),),
          backgroundColor: darktheme ? Colors.grey[900] : Colors.white, 
          iconTheme: IconThemeData(color: darktheme ? Colors.white : Colors.grey[800],),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...firstCourses.map((e) => Card(
                    color: darktheme ? Colors.grey[850] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ListTile(
                      title: Text(
                        e,
                        style: TextStyle(
                            fontSize: 17.0,
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      leading: Icon(
                        Icons.folder,
                        color: darktheme ? Colors.grey : Colors.grey,
                      ),
                      onTap: () {
                        switch (e) {
                          case 'Basic Electrical Technology':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1eHfltI3_p-8SC3UEHMF77f2C7x_H0a7w');
                            break;
                          case 'Biology for Engineers':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1mW-1X1Hjo-Cal-5yo5r2oRv8lnQVzLVs');
                            break;
                          case 'Engineering Chemistry':
                            _launchURL(
                                'https://drive.google.com/drive/folders/10xwjsrOHlt-p7Avq4_TAU1lKcfar9Brq');
                            break;
                          case 'Environmental Studies':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1k7pEgCFlajbKj977ILGo0EgosOBUKlUb');
                            break;
                          case 'Engineering Mathematics 1':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1GSl1slIsQvatng1zEEPHxEEPMWmHhgtq');
                            break;
                          case 'Problem Solving Using Computers':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1Fnf7HA_FCtrgOGNjs6Jc_YWFYKX7Ds1n');
                            break;
                          case 'Basic Electronics':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1NINpVvoAIoWxyG--mUtXgpf1aE2Um8dV');
                            break;
                          case 'Basic Mechanical Engineering':
                            _launchURL(
                                'https://drive.google.com/drive/folders/19r0HpIUvTelTq_eWGGurcr0bXTVJL0DU');
                            break;
                          case 'English':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1VPNazO6dQC6LJfJII3ormeDxXOm9epoA');
                            break;
                          case 'Engineering Mathematics 2':
                            _launchURL(
                                'https://drive.google.com/drive/folders/16DAnOou7kWIU_8g6U_n68UyAwaDuXG5S');
                            break;
                          case 'Mechanics of Solids':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1rgUYcC3p-op6d3IdgPLwtg0CNmSuT9Uw');
                            break;
                          case 'Engineering Physics':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1JSK0UjLKuQZSjDhMMTopfWcFJrG1toU9');
                            break;
                          case 'Physics Lab':
                            _launchURL(
                                'https://drive.google.com/drive/folders/1Ki9_g2-xBWYCNMej562n6L8hSZqsUnws');
                            break;
                          default:
                        }
                      },
                    )))
              ],
            ),
          ),
        ));
  }
}
