import 'package:flutter/material.dart';

int addAndDeleteIfFallOnSnakeOrLadder(
    int position1, BuildContext context, Duration duration) {
  if (position1 == 12) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You climbed up a Ladder'), duration: duration));
    position1 = 33;
  }
  if (position1 == 37) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You stepped into a Snake'), duration: duration));
    position1 = 17;
  }
  if (position1 == 46) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You climbed up a Ladder'), duration: duration));
    position1 = 67;
  }
  if (position1 == 50) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You climbed up a Ladder'), duration: duration));
    position1 = 70;
  }
  if (position1 == 62) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You stepped into a Snake'), duration: duration));
    position1 = 44;
  }
  if (position1 == 96) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You stepped into a Snake'), duration: duration));
    position1 = 78;
  }
  return position1;
}
