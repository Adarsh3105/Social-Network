import 'package:flutter/material.dart';

Container circularProgress(){
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.green),
    ),
  );
}

Container linearPgrogress(){
  return Container(
    alignment: Alignment.center,
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.green),
    ),
  );
}