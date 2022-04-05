// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:dicegram/new_snake_ladder/snakes_ladders.dart';
import 'package:flutter/material.dart';

Widget ImageItem(context) {
  return Stack(
    children: [
      Positioned(
        // Top Snake
        top: -35,
        left: 70,
        child: Image.asset(
          SnakesLaddersConst.snake,
          height: 180,
          width: 60,
        ),
      ),
      Positioned(
        // Right Snake
        top: 45,
        left: 200,
        child: Image.asset(
          SnakesLaddersConst.snake,
          height: 180,
          width: 60,
        ),
      ),
      Positioned(
        // Lowest Snake
        top: 125,
        left: 70,
        child: Image.asset(
          SnakesLaddersConst.snake_two,
          height: 180,
          width: 60,
        ),
      ),
      Positioned(
        // Left Ladder
        top: 40,
        left: -10,
        child: Image.asset(
          SnakesLaddersConst.ladders,
          height: 180,
          width: 60,
        ),
      ),
      Positioned(
        // Lowest ladder
        top: 128,
        right: 30,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(155 / 360),
          child: Image.asset(
            SnakesLaddersConst.ladders,
            height: 180,
            width: 60,
          ),
        ),
      ),
      Positioned(
        // Centre ladder
        top: 45,
        left: 83,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(320 / 360),
          child: Image.asset(
            SnakesLaddersConst.ladders,
            height: 170,
            width: 70,
          ),
        ),
      ),
    ],
  );
}
// }
