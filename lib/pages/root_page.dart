import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:toys/models/user.dart';
import 'package:toys/pages/auth_page.dart';
import 'package:toys/pages/main_page.dart';
import 'package:toys/services/auth.dart';
import 'package:toys/services/datastore.dart';
import 'package:toys/widgets/loading.dart';

enum authResult { LOGGED_IN, NOT_LOGGED_IN }

class RootPage extends StatefulWidget {
  Auth auth;
  Datastore datastore;
  RootPage({this.auth, this.datastore});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String _userId;
  authResult _authStatus = authResult.NOT_LOGGED_IN;

  @override
  void initState() {
    super.initState();
    // Auth().getCurrentUser().then((user) {
    //   setState(() {
    //     if (user != null) {
    //       _userId = user?.uid;
    //     }
    //     _authStatus =
    //         _userId == null ? authResult.NOT_LOGGED_IN : authResult.LOGGED_IN;
    //   });
    // });
    
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user?.uid;
      });
    });
    setState(() {
      _authStatus = authResult.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      _authStatus = authResult.NOT_LOGGED_IN;
      _userId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case authResult.NOT_LOGGED_IN:
        return AuthPage();
        break;
      case authResult.LOGGED_IN:
        return Scaffold(body: Text(_userId),);
        break;
      default: return Scaffold(body: Center(child: circularProgress(context),));
    }
  }
}
