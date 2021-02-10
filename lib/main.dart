import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO: add initial launch screen using shared_preferences

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartupMenu(),
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
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Tech News",
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: NewsList(
          topic: "politics",
        ));
  }
}

// ignore: must_be_immutable
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

class StartupMenu extends StatefulWidget {
  @override
  _StartupMenuState createState() => _StartupMenuState();
}

class _StartupMenuState extends State<StartupMenu> {
  @override
  Widget build(BuildContext context) {
    Size deviceDimensions = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Topics", style: TextStyle(fontSize: 30)),
          Container(
            width: deviceDimensions.width / 1.3,
            height: deviceDimensions.height / 1.7,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(12.0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TopicForm(),
          ),
        ],
      ),
    ));
  }
}

class SelectionButton extends StatefulWidget {
  final Icon icon;
  final String topic;
  bool value = false;

  SelectionButton({this.icon, this.topic});

  @override
  _SelectionButtonState createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SwitchListTile(
        title: Text(widget.topic),
        secondary: widget.icon,
        value: widget.value,
        onChanged: (value) {
          setState(() {
            widget.value = value;
            print("Debug: Switch value = ${widget.value}");
          });
        },
      ),
    );
  }
}

class TopicForm extends StatefulWidget {
  List<SelectionButton> arr = [
    SelectionButton(
      icon: Icon(Icons.computer),
      topic: "Tech",
    ),
  ];

  @override
  TopicFormState createState() => TopicFormState();
}

class TopicFormState extends State<TopicForm> {
  void _apply() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String topics = pref.getString("topics");
    print("topics: " + topics);
    Map<String, bool> payload = {};
    widget.arr.forEach((element) {
      payload[element.topic] = element.value;
    });
    print("payload: " + payload.toString());
    await pref.setString("topics", payload.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: widget.arr[0]),
        Spacer(),
        FlatButton(
          onPressed: () {
            _apply();
          },
          child: Text("Done"),
          color: Colors.blue,
        )
      ],
    );
  }
}
