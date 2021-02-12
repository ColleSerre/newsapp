import 'package:flutter/material.dart';
import 'package:newsapp/TopicForm.dart';

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
            width: deviceDimensions.width / 1.2,
            height: deviceDimensions.height / 1.5,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(12.0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black54
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Expanded(
              child: TopicForm(),
            ),
          ),
        ],
      ),
    ));
  }
}
