import 'package:flutter/material.dart';

@immutable
class Notif {
  final String title;
  final String body;

  const Notif({@required this.title, @required this.body});
}
