import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class SecondYear extends StatelessWidget {
  final List<String> secondBranches = [
    "Aeronautical Engineering",
    "Automobile Engineering",
    "Biomedical Engineering",
    "Biotechnology",
    "Chemical Engineering",
    "Civil Engineering",
    "Computer & Communication Engineering",
    "Computer Science & Engineering",
    "Electrical & Electronics Engineering",
    "Electronics & Communication Engineering",
    "Industrial & Production Engineering",
    "Information Technology",
    "Electronics and Instrumentation Engineering",
    "Mechanical Engineering",
    "Mechatronics",
    "Media Technology",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
        appBar: AppBar(
          title: Text(
            "Second Year",
            style: TextStyle(
              color: darktheme ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
          iconTheme: IconThemeData(
            color: darktheme ? Colors.white : Colors.grey[800],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...secondBranches.map((e) => Card(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SemPage(e),
                            ));
                      },
                    )))
              ],
            ),
          ),
        ));
  }
}
// Hello from GitHub
class SemPage extends StatelessWidget {
  SemPage(this.branchname);
  final String branchname;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could Not Launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Second Year",
          style: TextStyle(
            color: darktheme ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
      ),
      backgroundColor: darktheme ? Colors.grey[900] : Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: darktheme ? Colors.grey[850] : Colors.white,
              child: ListTile(
                title: Text('Semester III',
                    style: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
                    )),
                leading: Icon(Icons.folder,
                    color: darktheme ? Colors.grey : Colors.grey),
                onTap: () {
                  switch (branchname) {
                    case "Aeronautical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B-mJPTxhqTORNVRhdjdRTG5SWGM');
                      break;
                    case "Automobile Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1iEOeuUjCSueAeDCjs-1QJS-kKTLJ900p');
                      break;
                    case "Biomedical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B1yWz4AaZ51URHZpUC1YQUdEdFE');
                      break;
                    case "Biotechnology":
                      _launchURL(
                          'https://drive.google.com/drive/folders/19QIAF8gbGqhiWJ4BmrNlHaxRcAmeofXt');
                      break;
                    case "Chemical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B6Qk-zoR6qaFYXAySVJVV1p4ZXc');
                      break;
                    case "Civil Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0BzCCKrPZ7YgNfkcxSGxwSnFQa2VVNGdlQXp3R1RHNEdvc3RyWk5zMTBSb2hxeW9ad2JBVEk');
                      break;
                    case "Computer & Communication Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1SWMkpWc3OIIsci1wmddVgWpm1rBixeok');
                      break;
                    case "Computer Science & Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1sbGz5J1C12evCFgIQNBzlsDB64U4qFzS');
                      break;
                    case "Electrical & Electronics Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1fgEXLZLYJrNjkQ5JzEzW_Qc5Yku_gUe8');
                      break;
                    case "Electronics & Communication Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B2UX_qjv8bYlbEFXOTdBZnR3ZGM');
                      break;
                    case "Industrial & Production Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B8Vq_2VCyqRXfkhhbmxBSlBmeDZBZnZjODY5enc5ZkwtSmNIeXNORWFPSU5qODBfcU1ObWc');
                      break;
                    case "Information Technology":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1-9-en2k5-2oBbaEYx9zi8WJKZLYrYbWs');
                      break;
                    case "Electronics and Instrumentation Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1kKuiiZjmXXkf8L1itSkEoQzoNTDpjjwX');
                      break;
                    case "Mechanical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/u/0/folders/0BxcIiO3eUGIyOWdkTjJzT3o5dm8');
                      break;
                    case "Mechatronics":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1mrSpjwJmiKfBUIm_eZpjNYxOzjmwPrHo');
                      break;
                    case "Media Technology":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1OwY7xXRDyOnlbWzjGJNZXV24Q85-QQ_z');
                      break;
                    default:
                  }
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: darktheme ? Colors.grey[850] : Colors.white,
              child: ListTile(
                title: Text('Semester IV',
                    style: TextStyle(
                      color: darktheme ? Colors.white : Colors.black,
                    )),
                leading: Icon(Icons.folder,
                    color: darktheme ? Colors.grey : Colors.grey),
                onTap: () {
                  switch (branchname) {
                    case "Aeronautical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B-mJPTxhqTORUDB1QnRRa01IVlU');
                      break;
                    case "Automobile Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1v5boij5g4IC4DQLlD_hrZNVNfEeQm8nC');
                      break;
                    case "Biomedical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1yJvCQ-BjHLEeKBBqZP-us9tK4ybdYcRD');
                      break;
                    case "Biotechnology":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1uV6m0SArIzD_jZZy-4v-a705D600etxE');
                      break;
                    case "Chemical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/12qBB9ooq9Yg6o3yI-jpw7QdYLqqQT_Pu');
                      break;
                    case "Civil Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0BzCCKrPZ7YgNfnVHb3k0N2VxUVl6REU5UE1DbUpaNU80ZFBXYmNjMEtsVll5LXMwZVVpbzA');
                      break;
                    case "Computer & Communication Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/18fL5otDFNnEhW4vHbKmy542_T8xIfwWv');
                      break;
                    case "Computer Science & Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1z6ajuaRWcb38fl1xcunlpKQ-maN1FLp-');
                      break;
                    case "Electrical & Electronics Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1y13GiUwV9Sf1Jf5HcWJ7PZyS1NOX8xwY');
                      break;
                    case "Electronics & Communication Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1MAjKNC6r1-61fakgqydSyjOO_qEC22JZ');
                      break;
                    case "Industrial & Production Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/0B3Tz3prYzfFOTi1td2hsVmdRdlE');
                      break;
                    case "Information Technology":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1--pSOa9x-_NRM2A0hKf_bWMtvSylW4h_');
                      break;
                    case "Electronics and Instrumentation Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1YMis-JKClLcAjyEM7zFAFLYdPoH60sZd');
                      break;
                    case "Mechanical Engineering":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1k1d3knSGeTZ3QUSMJAhgkpImHQQQbBdk');
                      break;
                    case "Mechatronics":
                      _launchURL(
                          'https://drive.google.com/drive/folders/1DLnz383h5QTbqz2-P-D5hj_ucrWxpsDh');
                      break;
                    case "Media Technology":
                      _launchURL(
                          'https://drive.google.com/drive/folders/19t4mk2QifLmbB-SnDGYjlF9ONOtuR3is');
                      break;
                    default:
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
