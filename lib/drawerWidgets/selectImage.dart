import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manipalleaks/main.dart';
import 'package:manipalleaks/widgets/homepage.dart';

class SelectImage extends StatefulWidget {
  final String downloadUrl;
  SelectImage(this.downloadUrl);
  @override
  _SelectImageState createState() => _SelectImageState(downloadUrl);
}

class _SelectImageState extends State<SelectImage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  File _imageFile;
  bool uploaded;
  var downloadAdresss;
  String downloadUrl;
  ImagePicker _imagePicker = ImagePicker();

  var imageUrl;
  _SelectImageState(this.downloadUrl);
  initState() {
    super.initState();
    getInitialUserProfile();
  }

  getInitialUserProfile() async {
    final FirebaseUser user = await auth.currentUser();
    Firestore.instance
        .collection('/users')
        .document(user.uid)
        .get()
        .then((value) {
      setState(() {
        imageUrl = value.data['imageUrl'];
        print(imageUrl);
      });
    }).catchError((e) => print(e));
  }

  Future getImage(bool isCamera) async {
    PickedFile image;
    if (isCamera) {
      image = await _imagePicker.getImage(
          source: ImageSource.camera, imageQuality: 5);
    } else {
      image = await _imagePicker.getImage(
          source: ImageSource.gallery, imageQuality: 5);
    }
    if (mounted)
      setState(() {
        if (image != null) {
          _imageFile = File(image.path);
          imageUrl = null;
        } else
          image = PickedFile(imageUrl);

        print(image.path);
        print(imageUrl);
      });
  }

  Future cropImage() async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(
          backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
          toolbarTitle: 'Cropper',
          toolbarColor: darktheme ? Colors.grey[900] : Colors.white,
          toolbarWidgetColor: darktheme ? Colors.white : Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    setState(() {
      _imageFile = croppedImage ?? _imageFile;
    });
  }

  Future uploadImage() async {
    final FirebaseUser user = await auth.currentUser();
    StorageReference reference =
        FirebaseStorage.instance.ref().child('${user.uid}');
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    // ignore: unused_local_variable
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    downloadAdresss = await reference.getDownloadURL();
    await Firestore.instance
        .collection('/users')
        .document(user.uid)
        .setData({'imageUrl': downloadAdresss}, merge: true)
        .then((value) => print('Profile Set'))
        .catchError((e) => print(e));
    if (mounted)
      setState(() {
        imageUrl = null;
        uploaded = true;
        downloadUrl = downloadAdresss;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: darktheme ? Colors.grey[900] : Colors.white,
        title: Text(
          'Select Profile Picture',
          style: TextStyle(color: darktheme ? Colors.white : Colors.grey[800]),
        ),
        iconTheme: IconThemeData(
          color: darktheme ? Colors.white : Colors.grey[800],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? Container(
                    height: 300.0,
                    width: 300.0,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: '$imageUrl',
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : null,
                  )
                : Container(
                    height: 300.0,
                    width: 300.0,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: imageUrl == null
                        ? Image.file(
                            _imageFile,
                            height: 300.0,
                            width: 300.0,
                          )
                        : Image.network('$imageUrl'),
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.green,
                  onPressed: () => getImage(true),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                FlatButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () => getImage(false),
                  child: Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            imageUrl == null
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.green,
                    onPressed: () {
                      cropImage();
                    },
                    child: Text(
                      'Crop',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Offstage(),
            imageUrl == null
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.green,
                    onPressed: () {
                      print(imageUrl);
                      if (imageUrl == null) uploadImage();
                      print(downloadUrl);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    },
                    child: Text(
                      'Set as Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Offstage()
          ],
        ),
      ),
    );
  }
}
