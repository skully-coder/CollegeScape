import 'package:flutter/material.dart';

class Contacts extends StatelessWidget {
  final List<String> categories = ["Emergency Contacts", ""];
  @override
  Widget build(BuildContext context) {
    return Card(
          child: ExpansionTile(
        title: Text('Test'),
        children: [
          Card(
            child: ListTile(
              title: Text("Test Content"),
            ),
          )
        ],
      ),
    );
  }
}
