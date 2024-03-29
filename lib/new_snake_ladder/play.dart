// ignore_for_file: prefer_const_constructors

import 'package:dicegram/new_snake_ladder/avatar-player.dart';
import 'package:flutter/material.dart';

class Play extends StatelessWidget {
  const Play({
    Key? key,
    required this.index,
    required this.totalPlayerOne,
    required this.totalPlayerTwo,
    // required this.currentPlayer
  }) : super(key: key);
  final int index, totalPlayerOne, totalPlayerTwo
      // currentPlayer
      ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (totalPlayerOne == (100 - index))
          // If player 1, then women emoji, otherwise man emoji.
          AvatarPlayer(
            player: 1,
            size: totalPlayerOne == totalPlayerTwo ? 8 : 3,
          ),
        if (totalPlayerTwo == (100 - index))
          AvatarPlayer(
            player: 2,
            size: 3,
          )
      ],
    );
  }
}
