import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String postID;
  final String userID;
  final String location;
  final String description;
  final String medialURL;
  final String username;
  final dynamic likes;

  Post({
  this.postID,
  this.userID,
  this.location,
  this.description,
  this.likes,
  this.medialURL,
  this.username,
  });

  factory Post.fromDocument(DocumentSnapshot doc){
      return Post(
        postID: doc['postID'],
        userID: doc['userID'],
        description: doc['caption'],
        location: doc['location'],
        medialURL: doc['mediaURL'],
        username: doc['Username'],
        likes: doc['likes'],
      );
  }

}