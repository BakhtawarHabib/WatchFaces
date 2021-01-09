import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddWatchFace extends StatefulWidget {
  @override
  _AddWatchFaceState createState() => new _AddWatchFaceState();
}

class _AddWatchFaceState extends State<AddWatchFace> {
  bool isVisible = false;
  var isLoading = true;
  File _image;
  var watchFaceName;
  var watchFaceImage;
  var watchFaceFile1;
  var watchFaceFile2;
  var file1;
  var file2;
  var userId;
  String watchFaceImagename = "";
  String file1name = "";
  String file2name = "";
  var animalCategory;

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    String fileName = basename(_image.path);
    watchFaceImagename = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('/assets/watchfaces/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    watchFaceImage = await firebaseStorageRef.getDownloadURL() as String;
    setState(() {});
  }

  Future getFile1() async {
    // ignore: deprecated_member_use
    File file = await FilePicker.getFile();

    setState(() {
      file1 = file;
    });
    String fileName = basename(file1.path);
    file1name = basename(file1.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('/assets/watchfaces/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file1);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    watchFaceFile1 = await firebaseStorageRef.getDownloadURL() as String;
    setState(() {});
  }

  Future getFile2() async {
    // ignore: deprecated_member_use
    File file = await FilePicker.getFile();

    setState(() {
      file2 = file;
    });
    String fileName = basename(file2.path);
    file2name = basename(file2.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('/assets/watchfaces/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file2);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    watchFaceFile2 = await firebaseStorageRef.getDownloadURL() as String;
    setState(() {});
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  Future _onPressed() async {
    Firestore.instance.collection("WatchFaces").add({
      "WatchFacesFile": {
        "Name": watchFaceName,
        "File2": watchFaceFile2,
        "File1": watchFaceFile1,
        "Image": watchFaceImage,
        "Imagename": watchFaceImagename,
        "File1name": file1name,
        "File2name": file2name,
      },
    }).then((value) {
      print(value.documentID);
      print(value);
    });
//
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Add Watch Face',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        isLoading = true;
                      });

                      _onPressed();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWatchFace()));
                    }
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      buildNameField(),
                      new Padding(
                        padding: const EdgeInsets.only(
                          top: 50.0,
                          bottom: 20.0,
                        ),
                        child: new RaisedButton(
                          onPressed: () => getImage(),
                          child: new Text("Open image"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Image $_image"),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                        child: new RaisedButton(
                          onPressed: () => getFile1(),
                          child: new Text("Open file1"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("File $file1"),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                        child: new RaisedButton(
                          onPressed: () => getFile2(),
                          child: new Text("Open file2"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("File2 $file2"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget buildNameField() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Watch Face Name",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ))),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                hintText: ("Enter watchface name"),
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: Colors.black,
                )),
            onSaved: (String value) {
              watchFaceName = value;
            },
            validator: (String value) {
              if (value.isEmpty) {
                return ('Enter watchface name');
              }
              return null;
            },
          ),
        ),
      )
    ]);
  }
}
