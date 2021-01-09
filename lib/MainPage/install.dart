import 'dart:ui';
import 'package:flutter/material.dart';

class Install extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "How to Install",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "1 :See different watches",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Image.asset(
              "assets/s4.jpg",
              height: 500,
              width: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "2: Click on button",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Image.asset(
              "assets/s3.jpg",
              height: 500,
              width: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "3: File has downloaded in appmanager folder (with image)",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Image.asset(
              "assets/s2.jpg",
              height: 500,
              width: 400,
            ),
          ],
        ),
      ),
    );
  }
}
