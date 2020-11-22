import 'package:flutter/material.dart';
import 'package:manipalleaks/main.dart';

class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darktheme ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: darktheme ? Colors.grey[900] : Colors.purple,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Version History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                    color: darktheme ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      leading: Icon(
                        Icons.update,
                        color: darktheme ? Colors.white : Colors.purple,
                      ),
                      title: Text(
                        "Update 1.0.4",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Update Details",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                    )),
                Card(
                    color: darktheme ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      leading: Icon(
                        Icons.update,
                        color: darktheme ? Colors.white : Colors.purple,
                      ),
                      title: Text(
                        "Update 1.0.3",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Update Details",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                    )),
                Card(
                    color: darktheme ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      leading: Icon(
                        Icons.update,
                        color: darktheme ? Colors.white : Colors.purple,
                      ),
                      title: Text(
                        "Update 1.0.2",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Update Details",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                    )),
                Card(
                    color: darktheme ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      leading: Icon(
                        Icons.update,
                        color: darktheme ? Colors.white : Colors.purple,
                      ),
                      title: Text(
                        "Update 1.0.1",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Update Details",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                    )),
                Card(
                    color: darktheme ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      leading: Icon(
                        Icons.update,
                        color: darktheme ? Colors.white : Colors.purple,
                      ),
                      title: Text(
                        "Update 1.0.0",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        "Update Details",
                        style: TextStyle(
                            color: darktheme ? Colors.white : Colors.black),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
