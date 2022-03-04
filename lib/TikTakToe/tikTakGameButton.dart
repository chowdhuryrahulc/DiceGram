import 'package:flutter/material.dart';

class GameButton {
  final id;
  String text;
  Color bg; // bg is background
  bool enabled;

  GameButton(
      {this.id, this.text = "", this.bg = Colors.grey, this.enabled = true});
}
