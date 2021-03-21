import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialNetwork/screens/homePage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.green, 
      ),
      home: HomePage(),
    );
  }
}
