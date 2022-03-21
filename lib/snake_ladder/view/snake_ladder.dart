// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:math';
import 'package:dicegram/helpers/user_service.dart';
import 'package:spring/spring.dart';
import 'package:demoji/demoji.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/snake_ladder/consts/dices.dart';
import 'package:dicegram/snake_ladder/snakeLadderDatabase.dart';
import 'package:dicegram/snake_ladder/widgets/dice-item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:dicegram/snake_ladder/widgets/image-item.dart';
import 'package:dicegram/snake_ladder/widgets/play.dart';

class SnakeLadder extends StatefulWidget {
  const SnakeLadder({
    Key? key,
    required this.gameId,
    required this.players,
    required this.playersName,
    required this.chatId,
    required this.onEnd,
  }) : super(key: key);
  final String gameId;
  final List<String> players;
  final List<String> playersName;
  final String chatId;
  final VoidCallback onEnd;

  @override
  _SnakeLadderState createState() => _SnakeLadderState();
}

class _SnakeLadderState extends State<SnakeLadder> {
  Stream? getSnakeLadderDataStream;
  Duration duration = Duration(milliseconds: 500);
  String? player1Name;
  String? player2Name;

  @override
  void initState() {
    super.initState();
    initFunc();
  }

  initFunc() async {
    int position1 = 1;
    int position2 = 1;
    Map<String, dynamic> positionAndActivePlayerMap = {
      widget.players[0]: position1,
      widget.players[1]: position2,
      'activePlayer': widget.players[0]
    };
    snakeLadderDatabase()
        .sendSnakeLadderPositionData(widget.gameId, positionAndActivePlayerMap);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: snakeLadderDatabase().getSnakeLadderPositionData(widget.gameId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: AnimationLimiter(
                    child: Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange.shade300),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(color: Colors.orange.shade100)
                            ]),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(3),
                            addAutomaticKeepAlives: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 10),
                            itemCount: 100,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var color = index % 2 == 0
                                  ? Colors.black38
                                  : Colors.orange[300];
                              return Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(color: color),
                                    child: Center(
                                      // For 100 only
                                      child: (100 - index) == 100
                                          ? Text(
                                              Demoji.house,
                                              style: TextStyle(fontSize: 18),
                                            )
                                          : Text(
                                              (100 - index).toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                    ),
                                  ),
                                  Play(
                                    // Real position of the player
                                    totalPlayerOne:
                                        snapshot.data[widget.players[0]],
                                    totalPlayerTwo:
                                        snapshot.data[widget.players[1]],
                                    index: index,
                                  )
                                ],
                              );
                            }),
                      ),
                      ImageItem(context), // All the laders and Snakes
                    ]),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            FutureBuilder(
                                future: snakeLadderDatabase()
                                    .searchUserNamefromIdAndShowInSnakeLadderGame(
                                        widget.players[0]),
                                builder:
                                    (context, AsyncSnapshot futureSnapshot) {
                                  if (futureSnapshot.hasData) {
                                    return Text(
                                      futureSnapshot.data['username']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: futureSnapshot.data['id'] ==
                                                  snapshot.data['activePlayer']
                                              ? Colors.red
                                              : Colors.green),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                            FutureBuilder(
                                future: snakeLadderDatabase()
                                    .searchUserNamefromIdAndShowInSnakeLadderGame(
                                        widget.players[1]),
                                builder:
                                    (context, AsyncSnapshot futureSnapshot) {
                                  if (futureSnapshot.hasData) {
                                    return Text(
                                      futureSnapshot.data['username']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: futureSnapshot.data['id'] ==
                                                  snapshot.data['activePlayer']
                                              ? Colors.red
                                              : Colors.green),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                })
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            initFunc();
                            number = 1;
                          },
                          child: Text('Reset'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // End updates gameId, gameName, player.uid,
                            //! uid just keeps adding, adding. Makes 3-5 players.
                            //? Why use players, users. different different??
                            //? Where the SnakeLadder inPlaying data is stored??
                            GameService()
                                .deleteGame(widget.gameId, widget.chatId);
                            widget.onEnd();
                          },
                          child: Text('End'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                        ),
                        Dice(snapshot)
                        // Footer(snakeLaddersStore: _snakesLaddersStore, diceTwo: dice),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  int number = 1;
  int addAndDeleteIfFallOnSnakeOrLadder(int position1) {
    if (position1 == 12) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You climbed up a Ladder'), duration: duration));
      position1 = 33;
    }
    if (position1 == 37) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You stepped into a Snake'), duration: duration));
      position1 = 17;
    }
    if (position1 == 55) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You climbed up a Ladder'), duration: duration));
      position1 = 58;
    }
    if (position1 == 50) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You climbed up a Ladder'), duration: duration));
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

  int dontAllowMovementIfPositionIsHigherThan100(int position1, int number) {
    if (position1 == 100) {
      showResetDialog();
      return 1;
    } else if (position1 > 100) {
      position1 = position1 - number;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Need ${100 - position1} more points to win'),
        duration: duration,
      ));
    }
    return position1;
  }

  showResetDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Do you want to start a new game?',
              style: TextStyle(color: Colors.black54),
            ),
            backgroundColor: Colors.orange[100],
            elevation: 10,
            actions: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        initFunc() // this
                      },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  void rollDice(AsyncSnapshot snapshot) {
    number = 1 + Random().nextInt(6);
    if (widget.players[0] == UserServices.userId) {
      print('User is First');
      if (snapshot.data['activePlayer'] == UserServices.userId) {
      int position1 = snapshot.data[widget.players[0]] + number;
      position1 = addAndDeleteIfFallOnSnakeOrLadder(position1);
      position1 = dontAllowMovementIfPositionIsHigherThan100(position1, number);
      // int position2 = 1;
      Map<String, dynamic> positionAndActivePlayerMap = {
        widget.players[0]: position1,
        widget.players[1]: snapshot.data[widget.players[1]],
        'activePlayer': widget.players[1]
      };
      snakeLadderDatabase().updateSnakeLadderPositionData(
          widget.gameId, positionAndActivePlayerMap);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not Your Turn'), duration: duration));
    }
    }
    if (widget.players[1] == UserServices.userId) {
      print('User is Second');
      if (snapshot.data['activePlayer'] == UserServices.userId) {
      int position2 = snapshot.data[widget.players[1]] + number;
      position2 = addAndDeleteIfFallOnSnakeOrLadder(position2);
      position2 = dontAllowMovementIfPositionIsHigherThan100(position2, number);
      // int position2 = 1;
      Map<String, dynamic> positionAndActivePlayerMap = {
        widget.players[0]: snapshot.data[widget.players[1]],
        widget.players[1]: position2,
        'activePlayer': widget.players[0]
      };
      snakeLadderDatabase().updateSnakeLadderPositionData(
          widget.gameId, positionAndActivePlayerMap);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not Your Turn'), duration: duration));
    }
    }
    // if (snapshot.data['activePlayer'] == UserServices.userId) {
    //   int position1 = snapshot.data[widget.players[0]] + number;
    //   position1 = addAndDeleteIfFallOnSnakeOrLadder(position1);
    //   position1 = dontAllowMovementIfPositionIsHigherThan100(position1, number);
    //   // int position2 = 1;
    //   Map<String, dynamic> positionAndActivePlayerMap = {
    //     widget.players[0]: position1,
    //     widget.players[1]: snapshot.data[widget.players[1]],
    //     'activePlayer': widget.players[1]
    //   };
    //   snakeLadderDatabase().updateSnakeLadderPositionData(
    //       widget.gameId, positionAndActivePlayerMap);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Not Your Turn'), duration: duration));
    // }
  }

  Widget Dice(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          rollDice(snapshot);
        },
        child: DiceItem(
          dice: DicesConst.dice(
            number.toString(),
          ),
          color: snapshot.data['activePlayer'] == UserServices.userId
              ? Colors.transparent
              : Colors.black38,
          springController: SpringController(initialAnim: Motion.play),
        ),
      ),
    );
  }
}
