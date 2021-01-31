import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [HexColor("#ffafbd"), HexColor("#ffc3a0")])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Container(
              margin: EdgeInsets.only(top: 15),
              child: Center(
                  child: Text(
                "News API",
                style: TextStyle(color: Colors.black, fontSize: 30),
              )),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body: NewsList()),
    );
  }
}

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(
          "http://newsapi.org/v2/top-headlines?country=us&from=2020-12-31&sortBy=publishedAt&apiKey=f5d7d2d6ea364425a88b196b2af3d53f"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = jsonDecode(snapshot.data.body);
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async =>
                    await canLaunch(data["articles"][index]["url"])
                        ? await launch(data["articles"][index]["url"])
                        : throw "Could not launch url",
                child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.only(
                        right: 40, left: 17, top: 17, bottom: 17),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 3),
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      Text("${data["articles"][index]["title"]}",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      Text("${data["articles"][index]["description"]}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ])),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
