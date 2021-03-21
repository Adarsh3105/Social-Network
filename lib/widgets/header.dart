import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText,removeBackButtom=false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButtom?false:true,
    backgroundColor: Theme.of(context).accentColor,
    title: (Text(
      titleText,
      style: TextStyle(
        fontFamily: isAppTitle ? 'Signatra' : '',
        fontSize: isAppTitle ? 50 : 22,
        color: Colors.white,
      ),
    )),
    centerTitle: true,
  );
}
