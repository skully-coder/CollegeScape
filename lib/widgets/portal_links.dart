import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PortalLinks extends StatelessWidget {
  final List<String> linkname = [
    "SLCM Portal",
    "SIS Portal",
    "Student Clubs And Projects",
    "Library Portal",
    "Hostel Booking Portal",
    "Room Booking Portal",
    "Impartus Lecture Capture Portal",
    "I-On Portal",
    "Marena Sport Complex Portal",
    "Exam Portal",
  ];
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could Not Launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ...linkname.map((e) => Card(
                  color: darktheme ? Colors.grey[850] : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      Icons.link,
                      color: darktheme ? Colors.lightBlue : Colors.blue,
                    ),
                    title: Text(e,
                        style: TextStyle(
                          color: darktheme ? Colors.white : Colors.black,
                        )),
                    onTap: () {
                      switch (e) {
                        case "SLCM Portal":
                          // this._openUrl('https://slcm.manipal.edu/',
                          //     "SLCM Portal", context);
                          _launchURL('https://slcm.manipal.edu/');
                          break;
                        case "SIS Portal":
                          // this._openUrl('https://sis.manipal.edu/',
                          //     "SIS Portal", context);
                          _launchURL('https://sis.manipal.edu/');
                          break;
                        case "Library Portal":
                          // this._openUrl(
                          //     'http://libportal.mahe.manipal.net/MIT/MIT.aspx',
                          //     "Library Portal",
                          //     context);
                          _launchURL(
                              'http://libportal.mahe.manipal.net/MIT/MIT.aspx');
                          break;
                        case "Hostel Booking Portal":
                          // this._openUrl(
                          //     'https://hostel.manipal.edu/studloginregister.aspx',
                          //     "Hostel Booking Portal",
                          //     context);
                          _launchURL(
                              'https://hostel.manipal.edu/studloginregister.aspx');
                          break;
                        case "Room Booking Portal":
                          // this._openUrl('https://prod.cribblservices.com/#/',
                          //     "Room Booking Portal", context);
                          _launchURL('https://prod.cribblservices.com/#/');
                          break;
                        case "Impartus Lecture Capture Portal":
                          // this._openUrl('http://a.impartus.com/',
                          //     "Impartus Lecture Capture Portal", context);
                          _launchURL('http://a.impartus.com/');
                          break;
                        case "I-On Portal":
                          // this._openUrl('https://customer.i-on.in:9443/',
                          //     "I-On Portal", context);
                          _launchURL('https://customer.i-on.in/');
                          break;
                        case "Marena Sport Complex Portal":
                          // this._openUrl('https://sports.manipal.edu/',
                          //     "Marena Sports Complex Portal", context);
                          _launchURL(
                              'https://sports.manipal.edu/marena/Page.aspx?pg=rg');
                          break;
                        case "Exam Portal":
                          // this._openUrl(
                          //     "https://manipal.examcloud.in/slogin.php",
                          //     "Exam Portal",
                          //     context);
                          _launchURL("https://manipal.examcloud.in/slogin.php");
                          break;
                        case "Student Clubs And Projects":
                          _launchURL("https://clubs.mitportals.in");
                          break;
                        default:
                      }
                    },
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                )),
          ],
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
                  backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
                  title: Text(
                    urlName,
                    style: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                body: WebView(
                  initialUrl: url,
                ),
              )));
    }
  }
}
