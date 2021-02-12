import 'package:flutter/material.dart';

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
    return SwitchListTile(
      title: Text(widget.topic),
      secondary: widget.icon,
      value: widget.value,
      onChanged: (value) {
        setState(() {
          widget.value = value;
          print("Debug: ${widget.topic} value = ${widget.value}");
        });
      },
    );
  }
}
