import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socialNetwork/widgets/header.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  String username;
  final formkey = GlobalKey<FormState>();
  //bool removeBackButton=false;

  //final scaffoldkey= GlobalKey<ScaffoldState>();
  saveusername () {
    final form=formkey.currentState;
    if(form.validate()){
    form.save();
    //SnackBar snackBar= SnackBar(content: Text('Welcome $username'),backgroundColor: Theme.of(context).accentColor,);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome $username"),duration: Duration(seconds: 2),),);

     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome $username"),),);

    
     Timer(Duration(seconds: 2), (){
           Navigator.pop(context, username);

     });
     
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, titleText: 'Create Account',removeBackButtom :true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Text('Create a new profile',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              // decoration: BoxDecoration(
              //     border: Border.all(
              //   color: Colors.blue,
              // )),
              child: Form(
                key: formkey,
                autovalidateMode:AutovalidateMode.always ,
                child: TextFormField(
                  validator: (val){
                    if(val.trim().length<3){
                      return 'Username too short!';
                    }else if(val.trim().length>20){
                      return 'Username too long!';
                    }
                    else
                      return null;
                  },
                  onSaved: (val) => username = val,
                  decoration: InputDecoration(
                    hintText: 'Name should be atleast 3 character long',
                    labelText: 'Username',
                  ),
                ),
              ),
            ),
          ),
          Container(
            //decoration: BoxDecoration(shape: BoxShape.circle,),
            child: ElevatedButton(
              onPressed: saveusername,
              child: Text(
                'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
