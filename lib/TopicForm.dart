import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newsapp/SelectionButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicForm extends StatefulWidget {
  SharedPreferences prefs;
  Map<dynamic, dynamic> topicList = {};
  List<SelectionButton> arr = [
    SelectionButton(
      icon: Icon(Icons.clear_all_sharp),
      topic: "General",
    ),
    SelectionButton(
      icon: Icon(Icons.science_outlined),
      topic: "Science",
    ),
    SelectionButton(
      icon: Icon(Icons.sports_basketball),
      topic: "Sports",
    ),
    SelectionButton(
      icon: Icon(Icons.music_note_outlined),
      topic: "Entertainment",
    ),
    SelectionButton(
      icon: Icon(Icons.healing_outlined),
      topic: "Health",
    ),
    SelectionButton(
      icon: Icon(Icons.computer),
      topic: "Technology",
    ),
    SelectionButton(
      icon: Icon(Icons.monetization_on_sharp),
      topic: "Business",
    ),
  ];

  @override
  TopicFormState createState() => TopicFormState();
}

class TopicFormState extends State<TopicForm> {
  void _apply(SharedPreferences pref) async {
    String topics = pref.getString("topics");
    print("topics: " + topics.toString());
    Map<String, bool> payload = {};
    widget.arr.forEach((element) {
      payload[element.topic] = element.value;
    });
    print("payload: " + json.encode(payload));
    await pref.setString("topics", json.encode(payload));
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceDimensions = MediaQuery.of(context).size;
    SharedPreferences.getInstance().then((value) async => {
          widget.prefs = value,
          widget.topicList = json.decode(widget.prefs.getString("topics")),
        });
    return Column(
      children: [
        Container(
          height: deviceDimensions.height / 1.8,
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: widget.arr.length,
            itemBuilder: (context, index) => widget.arr[index],
          ),
        ),
        Spacer(),
        RaisedButton(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          onPressed: () => _apply(widget.prefs),
          child: Text("Done",
              style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
  }
}
