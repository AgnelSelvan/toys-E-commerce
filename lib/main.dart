import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:toys/models/user.dart';
import 'package:toys/pages/root_page.dart';
import 'package:toys/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOYS',
      theme: ThemeData(fontFamily: 'Josefin', primaryColor: Colors.grey[100]),
      home: RootPage(),
    );
  }
}