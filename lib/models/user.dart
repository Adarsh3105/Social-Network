import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String username;
  final String email;
  final String photourl;
  final String displayname;
  final String bio;

  User({
    this.id,
    this.email,
    this.bio,
    this.displayname,
    this.photourl,
    this.username,
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc['User-ID'],
      username: doc['Username'],
      photourl: doc['PhotoURL'],
      email: doc['Email-ID'],
      displayname: doc['Display Name'],
      bio: doc['Bio'],

    );
  }
}