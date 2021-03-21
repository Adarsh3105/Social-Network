import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'homePage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // bool isProfilePic=false;
  // PickedFile image;
  // File file;
  TextEditingController infocontroller=TextEditingController();
    TextEditingController namecontroller=TextEditingController();

  

  // setProfilePic() async{
  //    image = await ImagePicker().getImage(source: ImageSource.gallery);
  //     file=File(image.path);
  //   setState(() {
  //             isProfilePic=true;
  //       });

  // }

  changeProfileDetails()async{
    await userData.doc(currentUser.id).update({'Bio':infocontroller.text,'Display Name':namecontroller.text});
    Navigator.pop<Map>(context,{'bio':infocontroller.text,'name':namecontroller.text});
  }
  
  raiseError(){
    final snackbar=SnackBar(content: Text('Please enter atlease 3 characters and atmost 50 characters'),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //print('Error');
  }

  verifyDetails(){
    infocontroller.text.length>3&&infocontroller.text.length<51&&namecontroller.text.length>3?changeProfileDetails():raiseError();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('Edit Profile',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed:()=>Navigator.pop(context),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.check),
            onPressed: ()=>verifyDetails(),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: ()=>null,
                child: CircleAvatar(
                    radius: 55,
                    backgroundImage:CachedNetworkImageProvider(currentUser.photourl),
                  ),
              ),
            ),
            TextFormField(
              controller: namecontroller,
              decoration: InputDecoration(hintText: 'Should be atleast 3 characters long',labelText: 'Change Display Name'),
              
            ),
            TextFormField(
              controller: infocontroller,
              decoration: InputDecoration(hintText: 'Tell us about yourself',labelText: 'Add a bio'),
              
            )
          ],
        ),
      ),
    );
  }
}
