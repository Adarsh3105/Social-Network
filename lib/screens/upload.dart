import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialNetwork/models/user.dart';
import 'package:socialNetwork/screens/homePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

  fromCamera() async {
    Navigator.pop(context);
    PickedFile image;
    image = await ImagePicker().getImage(source: ImageSource.camera);
    File file = File(image.path);
    setState(() {
      this.file = file;
    });
  }

  fromGallery() async {
    Navigator.pop(context);
    PickedFile image;
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File file = File(image.path);
    setState(() {
      this.file = file;
    });
  }

  addURLtoFirestore({String mediaURL, String caption, String location}) {
    postData.doc(widget.currentUser.id).collection('User Posts').doc(postId).set({
      "mediaURL":mediaURL,
      "caption":caption,
      "location":location,
      "postID":postId,
      "Username":widget.currentUser.username,
      "userID":widget.currentUser.id,
      "timestamp":timestamp,
      "likes":{},
    });
    captionController.clear();
    locationController.clear();
    setState(() {
          file=null;
          isUploading=false;
          postId=Uuid().v4();
        });
  }

  Future<String> addToStorage(file) async {
    UploadTask uploadTask = storageRef.child('post_$postId.jpg').putFile(file);
    //TaskSnapshot storageSnap=await uploadTask.Com,
    String downloadURL = await (await uploadTask).ref.getDownloadURL();
    return downloadURL;
  }

  uploadPostToServer() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaURL = await addToStorage(file);
    addURLtoFirestore(
      mediaURL: mediaURL,
      caption: captionController.text,
      location: locationController.text,
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imagefile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(imagefile, quality: 85),
      );
    setState(() {
      file = compressedImageFile;
    });
  }
  
  getCurrentLocation() async{
    //Geolocator geolocator=Geolocator();
    Position location= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks= await placemarkFromCoordinates(location.latitude, location.longitude);
    print(placemarks[0]);
    setState(() {
          locationController.text= '${placemarks[0].locality},${placemarks[0].country}';
        });
    
  }

  Scaffold editorScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButton(
          icon: Icon(Icons.cancel, color: Colors.white),
          onPressed: () => setState(() {
            file = null;
          }),
        ),
        title: Text(
          'Upload post',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isUploading ? null : uploadPostToServer,
            child: Text(
              'Post',
              style: TextStyle(
                color: isUploading ? Colors.grey : Colors.white,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading ? LinearProgressIndicator() : Text(''),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                //border: ,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(file),
                ),
              ),
            ),
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: captionController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.book_rounded,
                    color: Colors.blue,
                  ),
                  hintText: 'Add a caption',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Form(
              child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                ),
                hintText: 'Add location',
                border: InputBorder.none,
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 100.0, right: 100),
            child: ElevatedButton.icon(
              onPressed: () => getCurrentLocation(),
              //child: Text('Current Location'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40))),
              label: Text(
                'Use current location',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  showDialogue(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text('Upload from camera'),
                onPressed: () => fromCamera(),
              ),
              SimpleDialogOption(
                child: Text('Upload from gallery'),
                onPressed: () => fromGallery(),
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container uploadSplashScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      height: orientation == Orientation.portrait ? 300 : 200,
      color: Theme.of(context).accentColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 150)),
          SvgPicture.asset(
            'assets/images/upload.svg',
            alignment: Alignment.center,
            height: 280,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple[300],
                fixedSize: Size.fromWidth(100),
              ),
              onPressed: () => showDialogue(context),
              child: Text(
                'Upload',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? uploadSplashScreen() : editorScreen();
  }
}
