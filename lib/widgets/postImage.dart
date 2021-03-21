import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialNetwork/models/post.dart';
import 'package:socialNetwork/screens/homePage.dart';
import 'package:socialNetwork/widgets/cachedNetworkImage.dart';
import 'package:socialNetwork/widgets/progress.dart';

final postData = FirebaseFirestore.instance.collection('posts');
bool isLiked=false;
bool showHeart=false;
Post currentpostdata;
class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  int getLikesCount(Map likes) {
    int count = 0;
    likes.values.forEach((element) {
      if (element == true) {
        count++;
      }
    });
    return count;
  }

  // sortByTimeStamp() {
  //   postData.doc(currentUser.id).collection('User Posts').orderBy("timestamp",);
  // }
  addlike(userid,postid,likes) async{
    final currentUserId=currentUser.id;
    bool isLiked=likes[currentUserId]==true;
     if(isLiked==true){
      postData.doc(userid).collection('User Posts').doc(postid).update({'likes.$currentUserId':false});
      setState(() {
        isLiked=false;
        likes[currentUserId]=false;
            });
    }
    else if(!isLiked){
      postData.doc(userid).collection('User Posts').doc(postid).update({'likes.$currentUserId':true});
      setState(() {
        isLiked=true;
        likes[currentUserId]=true;
        showHeart=true;
        Timer(Duration(milliseconds: 500),(){
          setState(() {
            showHeart=false;
                    });
        });
            });
    }
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: postData
            .doc(currentUser.id)
            .collection('User Posts')
            .get(), //postData.doc(currentUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return circularProgress();
          else if (snapshot.hasError) {
            return circularProgress();
          }
          //sortByTimeStamp();
          List<Post> userPosts = [];
          List<bool> likeState=[];
          snapshot.data.docs.forEach((val) {
            Post current=Post.fromDocument(val);
            userPosts.add(current);
          if(current.likes[currentUser.id]==null){
             likeState.add(false);
            }
          else  likeState.add(current.likes[currentUser.id]);
          });
          return ListView.builder(
            shrinkWrap: true,
            itemCount: userPosts.length,
            itemBuilder: (context, index) => Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(currentUser.photourl),
                    radius: 20.0,
                  ),
                  title: Text(currentUser.username),
                  subtitle: Text(userPosts[index].location),
                ),
                GestureDetector(
                  onDoubleTap: () => addlike(userPosts[index].userID,userPosts[index].postID, userPosts[index].likes),
                  child: Container(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      //height: 50,
                      // width: 250,
                      children:[ cachedNetworkImage(
                        userPosts[index].medialURL,
                      ),
                      showHeart?
                      Animator(
                        cycles: 0,
                        tween: Tween(begin: 0.1,end: 2.5),
                        duration: Duration(milliseconds: 500),
                        curve: Curves.bounceOut,
                        builder: (context,animatorState,child)=>Transform.scale(
                          scale: animatorState.value,
                          child: Icon(Icons.favorite_rounded,color: Colors.red,),
                          ),
                        )
                      :Text(''),
                      ]
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:16.0,bottom: 4.0,top: 8),
                      child: Text(currentUser.displayname,style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:16.0,bottom: 4.0,top: 8),
                      child: Text(userPosts[index].description),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        getLikesCount(userPosts[index].likes).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' likes',style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: likeState[index]?Icon(Icons.favorite_rounded,color:Colors.red):Icon(Icons.favorite_border),
                      onPressed: () => addlike(userPosts[index].userID,userPosts[index].postID,userPosts[index].likes),//addlike(userPosts[index].postID),
                    ),
                    IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () => print('Comment')),
                  ],
                )
              ],
            ),
          );
        });
  }
}
