import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsList extends StatefulWidget {
  String topic;
  var date = DateTime.now();
  String url;
  NewsList({
    this.topic,
  });

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    widget.url =
        "http://newsapi.org/v2/top-headlines?country=us&category=${widget.topic}&apiKey=f5d7d2d6ea364425a88b196b2af3d53f";
    return FutureBuilder(
      future: http.get(widget.url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          Map<String, dynamic> data = jsonDecode(snapshot.data.body);
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                widget.topic = widget.topic;
              });
            },
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async =>
                      await canLaunch(data["articles"][index]["url"])
                          ? await launch(data["articles"][index]["url"])
                          : throw "Could not launch url",
                  child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(children: [
                        data["articles"][index]["title"] == null
                            ? Container()
                            : Text("${data["articles"][index]["title"]}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                        data["articles"][index]["description"] == null
                            ? Container()
                            : Text("${data["articles"][index]["description"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                      ])),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
