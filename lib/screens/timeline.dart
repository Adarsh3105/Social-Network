import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialNetwork/widgets/header.dart';
import 'package:socialNetwork/widgets/progress.dart';
//import 'package:firebase_core/firebase_core.dart';

final userData = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  @override
  void initState() {
    super.initState();
  }

  // getUsers() async {
  //   final QuerySnapshot snapshot = await userData
  //       .where('isAdmin', isEqualTo: true)
  //       .where('posts', isGreaterThan: 2)
  //       .get();
  //   snapshot.docs.forEach((DocumentSnapshot snap) {
  //     print(snap.data());
  //   });
  // }


  

  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true, titleText: 'Social Network'),
      body: Text('Timeline'), 
      // StreamBuilder<QuerySnapshot>(
      //   stream: userData.snapshots(),
      //   builder: (context,snapshot){
      //     if(!snapshot.hasData){
      //       return circularProgress();
      //     }
      //     final List<Text> children=snapshot.data.docs.map((doc) => Text(doc['Name'])).toList();
      //       return Container(
      //         child: ListView(
      //             children: children,
      //         ),
      //       );
      //   },
      // ),
    );
  }
}
