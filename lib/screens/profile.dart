import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialNetwork/models/post.dart';
import 'package:socialNetwork/screens/edit_profile.dart';
import 'package:socialNetwork/screens/homePage.dart';
import 'package:socialNetwork/widgets/cachedNetworkImage.dart';
import 'package:socialNetwork/widgets/header.dart';
import 'package:socialNetwork/widgets/postImage.dart';
import 'package:socialNetwork/widgets/progress.dart';

final GoogleSignIn signout = GoogleSignIn();
final postData = FirebaseFirestore.instance.collection('posts');
String orientation="grid";

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {
    toggleView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () => setState(() {
                orientation="grid";
      }),
      color: orientation=="grid"?Theme.of(context).accentColor:Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => setState(() {
              orientation="list";
            }),
            color: orientation=="list"?Theme.of(context).accentColor:Colors.grey,
          ),
        ],
      ),
    );
  }
  changeDetails() async {
    details = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );
    if (details['bio'].length > 0)
      setState(() {
        isBio = true;
        bios = details['bio'];
        name = details['name'];
      });
  }

  String bio, bios, name;
  Map details = {'bio': '', 'name': ''};
  bool isBio = false;
  Column profileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                radius: 55,
                backgroundImage:
                    CachedNetworkImageProvider(currentUser.photourl),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 0),
                      child: TextButton(
                        onPressed: () => print('Posts'),
                        child: Text(
                          '13',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 0),
                      child: TextButton(
                        onPressed: () => print('Followers'),
                        child: Text(
                          '1',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextButton(
                        onPressed: () => print('Following'),
                        child: Text(
                          '2',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Posts',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Followers',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        'Following',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 220,
                        child: ElevatedButton(
                          onPressed: () => changeDetails(),
                          child: Text(
                            'Edit Profile',
                          ),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            !isBio ? currentUser.displayname : name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Text(
            !isBio ? currentUser.bio : bios,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  //   showGridView() async{

  // }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          header(context, isAppTitle: false, titleText: currentUser.username),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          //physics: AlwaysScrollableScrollPhysics(), // new
          children: <Widget>[
            profileHeader(),
            Padding(padding: EdgeInsets.only(top: 50)),
            Divider(
              height: 10,
            ),
            toggleView(),
            Padding(
              padding: const EdgeInsets.only(top:12.0),
              child: Divider(),
            ),
            orientation=="list"?PostImage():FutureBuilder<QuerySnapshot>(
                future: postData.doc(currentUser.id).collection('User Posts').get(),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                  return circularProgress();

                List<GridTile> gridTiles=[];
                snapshot.data.docs.forEach((element) {
                Post images=Post.fromDocument(element);
                gridTiles.add(GridTile(child:cachedNetworkImage(images.medialURL)),);
              });
                  return  GridView.count(
                  children: gridTiles,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  shrinkWrap: true,
                  childAspectRatio: 1,

                );
                },

              ),
             
            //PostImage(),
          ],
        ),
      ),
    );
  }
}
