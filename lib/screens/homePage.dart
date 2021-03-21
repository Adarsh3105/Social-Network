import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialNetwork/screens/activity_feed.dart';
import 'package:socialNetwork/screens/new_user.dart';
import 'package:socialNetwork/screens/profile.dart';
import 'package:socialNetwork/screens/search.dart';
import 'package:socialNetwork/screens/timeline.dart';
import 'package:socialNetwork/screens/upload.dart';
import 'package:socialNetwork/models/user.dart';

final userData = FirebaseFirestore.instance.collection('users');
final postData = FirebaseFirestore.instance.collection('posts');
final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef =FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAuth = false;
  int pageIndex = 0;
  PageController pageController;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  createUserInDatabase() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userData.doc(user.id).get();
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewUser()));
      userData.doc(user.id).set(
        {
          'User-ID': user.id,
          'Username': username,
          'PhotoURL': user.photoUrl,
          'TimeStamp': timestamp,
          'Display Name': user.displayName,
          'Email-ID': user.email,
          'Bio': '',
        },
      );
      doc = await userData.doc(user.id).get();
    }

    currentUser = User.fromDocument(doc);
    print(currentUser.username);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      print("Signed in to: $account");
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInDatabase();
      setState(
        () {
          isAuth = true;
        },
      );
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  login() {
    googleSignIn.signIn();
    //print("Signed In!");
  }

  logout() {
    googleSignIn.signOut();
  }

  changePage(pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Scaffold authenticated() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: <Widget>[
          Timeline(),
          Search(),
          Upload(currentUser: currentUser),
          ElevatedButton(onPressed: logout, child: Text('Logout')),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).accentColor,
        // backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
              label: 'timeline', icon: Icon(Icons.timeline)),
          BottomNavigationBarItem(label: 'search', icon: Icon(Icons.search)),
          BottomNavigationBarItem(
            label: 'upload',
            icon: Icon(
              Icons.upload_rounded,
              size: 50,
            ),
          ),
          BottomNavigationBarItem(
              label: 'activity', icon: Icon(Icons.local_activity)),
          BottomNavigationBarItem(label: 'profile', icon: Icon(Icons.person)),
        ],
        onTap: changePage,
      ),
    );
  }

  Scaffold unAuthenticated() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Social Network',
              style: TextStyle(
                  fontFamily: "Signatra", fontSize: 90, color: Colors.white),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                height: 60,
                width: 260,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? authenticated() : unAuthenticated();
  }
}
