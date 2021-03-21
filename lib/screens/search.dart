import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socialNetwork/widgets/progress.dart';
import 'homePage.dart';
import 'package:socialNetwork/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchResults;

  handlesearch(String query) {
    Future<QuerySnapshot> user =
        userData.where('Username', isGreaterThanOrEqualTo: query).get();

    setState(() {
      searchResults = user;
    });
  }

  Container emptysearch(context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //   colors: [Theme.of(context).accentColor.withOpacity(0.5), Theme.of(context).primaryColor.withOpacity(0.5)],
      //   begin: Alignment.topLeft,
      //   end: Alignment.bottomRight,
      // )),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
            Text(
              'Find users to connect with',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
            )
          ],
        ),
      ),
    );
  }

  final clearText = TextEditingController();
  clear() {
    clearText.clear();
  }

  AppBar searchHeader() {
    return AppBar(
      backgroundColor: Colors.green,
      title: Form(
        child: TextFormField(
          onFieldSubmitted: handlesearch,
          decoration: InputDecoration(
              hintText: 'Search for a user',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                color: Colors.white,
                onPressed: clear,
              )),
          controller: clearText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadresults() {
      return FutureBuilder<QuerySnapshot>(
        future: searchResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          if (snapshot.hasError) {
            return circularProgress();
          }
          List<UserResult> results = [];
          snapshot.data.docs.forEach((doc) {
            User user = User.fromDocument(doc);
            UserResult person = UserResult(user);
            results.add(person
                //User(username: user.username,photourl: user.photourl),
                );
          });

          return ListView(
            children: results,
          );
        },
      );
    }

    return Scaffold(
      appBar: searchHeader(),
      body: searchResults == null ? emptysearch(context) : loadresults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User result;
  UserResult(this.result);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(result.photourl),
              ),
              title: Text(
                result.username,
              ),
              subtitle: Text(result.displayname),
            ),
          ),
          Divider(color: Colors.green,thickness: 0.3,)
        ],
      ),
    );
  }
}
