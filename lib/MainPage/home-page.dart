import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:watchfaces/MainPage/install.dart';
import 'package:watchfaces/MainPage/privacy.dart';

final imgUrl =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

var dio = Dio();
var dio2 = Dio();
var dio3 = Dio();

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  bool isLoading = false;
  var watchFaceName = [];
  var watchFaceImage = [];
  var watchFaceFile1 = [];
  var watchFaceFile2 = [];
  String imgname = '';
  String file1name = '';
  String file2name = '';
  var id;
  List document = [];
  TextEditingController searchController = new TextEditingController();
  String filter;

  TextStyle defaultStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );

  Future getWatchFaces() async {
    setState(() {
      isLoading = true;
    });
    Firestore.instance
        .collection("WatchFaces")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        id = result.documentID;
        document.add(id);
        var watchFace = (result.data["WatchFacesFile"]);

        watchFaceName.add(watchFace['Name']);
        watchFaceImage.add(watchFace['Image']);
        watchFaceFile1.add(watchFace['File1']);
        watchFaceFile2.add(watchFace['File2']);
        imgname = watchFace['Imagename'];
        file1name = watchFace['File1name'];
        file2name = watchFace['File2name'];
      });

      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  void getPermission() async {
    print("getPermission");
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    getPermission();
    getWatchFaces();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
    if ((received / total * 100).toStringAsFixed(0) == 100) {
      print("done");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawer: Drawer(
                child: ListView(children: [
              Container(
                  color: Colors.grey,
                  child: Column(children: [
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 250,
                                height: 270,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () async {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ViewAnimalCategory()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.white,
                          elevation: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Install()));
                                },
                                child: ListTile(
                                  leading: Icon(Icons.help),
                                  title: Text('How to install',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Privacy()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.white,
                          elevation: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.security),
                                title: Text(('Privacy Policy'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])),
            ])),
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                ('WATCH FACES APP'),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            backgroundColor: Colors.black,
            body: isLoading
                ? SpinKitDoubleBounce(
                    color: Colors.greenAccent[700],
                  )
                : Center(
                    child: ListView(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          width: 200,
                          color: Colors.white,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.green,
                              ),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(0.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: watchFaceName?.length ?? 0,
                            itemBuilder: (context, index) {
                              return filter == null || filter == ""
                                  ? InkWell(
                                      onTap: () {},
                                      child: Card(
                                        elevation: 7,
                                        semanticContainer: true,
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.green,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 30.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            watchFaceImage[
                                                                index]),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                  title: Text(
                                                      watchFaceName[index],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16)),
                                                  trailing: new RaisedButton(
                                                    color: Colors.green[400],
                                                    onPressed: () async {
                                                      String path = await ExtStorage
                                                          .getExternalStoragePublicDirectory(
                                                              ExtStorage
                                                                  .DIRECTORY_DOWNLOADS);
                                                      //String fullPath = tempDir.path + "/boo2.pdf'";
                                                      String fullPath =
                                                          "/storage/emulated/0/appmanager/" +
                                                              imgname;
                                                      // String fullPath1 =
                                                      //     "$path/test.pdf";
                                                      String fullPath1 =
                                                          "/storage/emulated/0/appmanager/" +
                                                              file1name;
                                                      String fullPath2 =
                                                          "/storage/emulated/0/appmanager/" +
                                                              file2name;
                                                      print(
                                                          'full path ${fullPath1}');

                                                      download2(
                                                          dio,
                                                          watchFaceFile2[index],
                                                          fullPath2);
                                                      download2(
                                                          dio,
                                                          watchFaceImage[index],
                                                          fullPath);
                                                      download2(
                                                          dio2,
                                                          watchFaceFile1[index],
                                                          fullPath1);
                                                      // download2(
                                                      //     dio3,
                                                      //     watchFaceFile2[0],
                                                      //     fullPath);
                                                      print(
                                                        watchFaceFile1[index],
                                                      );
                                                    },
                                                    child: new Text(
                                                      "Click to download",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    )
                                  : new Container();
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ]),
                  )));
  }
}
