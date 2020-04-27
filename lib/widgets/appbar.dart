import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toys/styles/custom.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Custom custom = Custom();
  final String title;
  MyAppBar({@required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        style: custom.appbarTitleTextStyle,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48);
}
