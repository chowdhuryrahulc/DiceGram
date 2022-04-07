// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_const_literals_to_create_immutables, void_checks

import 'dart:developer' as log;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/new_snake_ladder/addAndDeleteIfFallOnSnakeOrLadder.dart';
import 'package:dicegram/new_snake_ladder/dice-item.dart';
import 'package:dicegram/new_snake_ladder/dices.dart';
import 'package:dicegram/new_snake_ladder/play.dart';
import 'package:dicegram/new_snake_ladder/snakeLadderDatabase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spring/spring.dart';
import 'package:demoji/demoji.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'image-item.dart';

class SnakeLadder extends StatefulWidget {
  SnakeLadder(
      {Key? key,
      required this.gameId, //=> GameRoom => doc()
      required this.players,
      required this.playersName,
      required this.chatId,
      required this.onEnd,
      required this.isGameInitiated,
      this.inSingleChat})
      : super(key: key);
  String gameId;
  bool isGameInitiated;
  bool? inSingleChat = false;
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

  @override
  void initState() {
    super.initState();
    initFunc();
    addFieldsofUsersInGameRoom(widget.players, widget.gameId);
  }

  initFunc() async {
    int position1 = 1;
    int position2 = 1;
    print("players ${widget.players}");
    try {
      Map<String, dynamic> positionAndActivePlayerMap = {
        widget.players[0]: position1,
        widget.players[1]: position2,
        'activePlayer': widget.players[0]
      };
      snakeLadderDatabase().sendSnakeLadderPositionData(
          widget.gameId, positionAndActivePlayerMap);
    } catch (e) {
      log.log('Harammmm');
      print(e);
    }
  }

  showDialogIfOtherPersonsEngagedIsFalse() {
    if (widget.players[0] == UserServices.userId) {
      print('otherPlayerId is ${widget.players[1]}');
      return FirebaseFirestore.instance
          .collection('users')
          .doc(widget.players[1])
          .snapshots();
    } else if (widget.players[1] == UserServices.userId) {
      print('otherPlayerId is ${widget.players[0]}');
      return FirebaseFirestore.instance
          .collection('users')
          .doc(widget.players[0])
          .snapshots();
    }
  }

//todo: Do not need this. Instead gameId is chatId. And isInitilized is done from the lastPage.
  // updatePlayerId() async {
  //   await searchIfPlayerIsPresentInAnyGroupAndFetchDocomentIdofThatGroup()
  //       .then((value) {
  //     if (value != null) {
  //       widget.gameId = value;
  //       widget.isGameInitiated = true;
  //     }
  //   });
  // }

  String? otherPlayerUserId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: showDialogIfOtherPersonsEngagedIsFalse(),
        builder: (context1, AsyncSnapshot otherPersonEngagedOfNotSnapshot) {
          if (widget.players[0] == UserServices.userId) {
            otherPlayerUserId = widget.players[1];
          }
          if (widget.players[1] == UserServices.userId) {
            otherPlayerUserId = widget.players[0];
          }
          return StreamBuilder(
              stream: snakeLadderDatabase()
                  .getSnakeLadderPositionData(widget.gameId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 300.h,
                            width: 300.w,
                            child: AnimationLimiter(
                              child: Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orange.shade300),
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
                                              width: 100.w,
                                              height: 100.h,
                                              decoration:
                                                  BoxDecoration(color: color),
                                              child: Center(
                                                // For 100 only
                                                child: (100 - index) == 100
                                                    ? Text(
                                                        Demoji.house,
                                                        style: TextStyle(
                                                            fontSize: 18.sp),
                                                      )
                                                    : Text(
                                                        (100 - index)
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                              ),
                                            ),
                                            Play(
                                              totalPlayerOne: snapshot
                                                  .data[widget.players[0]],
                                              totalPlayerTwo: snapshot
                                                  .data[widget.players[1]],
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
                                      builder: (context,
                                          AsyncSnapshot future1Snapshot) {
                                        if (future1Snapshot.hasData) {
                                          return Text(
                                            future1Snapshot.data['username']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: future1Snapshot
                                                            .data['id'] ==
                                                        snapshot.data[
                                                            'activePlayer']
                                                    ? Colors.green
                                                    : Colors.red),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                  FutureBuilder(
                                      future: snakeLadderDatabase()
                                          .searchUserNamefromIdAndShowInSnakeLadderGame(
                                              widget.players[1]),
                                      builder: (context,
                                          AsyncSnapshot future2Snapshot) {
                                        if (future2Snapshot.hasData) {
                                          return Text(
                                            future2Snapshot.data['username']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: future2Snapshot
                                                            .data['id'] ==
                                                        snapshot.data[
                                                            'activePlayer']
                                                    ? Colors.green
                                                    : Colors.red),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  try {
                                    initFunc();
                                    //todo Added in SingleChat
                                    if (widget.inSingleChat == true) {
                                      setIsPlaying(
                                          chatDocId: widget.chatId,
                                          boolToSet: false);
                                    }
                                    deleteUsersFromGameRoom(
                                        widget.gameId, otherPlayerUserId!);
                                    GameService().deleteGame(
                                        widget.gameId, widget.chatId);
                                    widget.onEnd();
                                  } catch (e) {
                                    log.log('HaramKhor');
                                    print(e);
                                  }
                                },
                                child: Text('End'),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange)),
                              ),
                              Dice(snapshot, otherPersonEngagedOfNotSnapshot)
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
        });
  }

  int number = 1;
  int dontAllowMovementIfPositionIsHigherThan100(int position1, int number) {
    if (position1 > 100) {
      position1 = position1 - number;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Need ${100 - position1} more points to win'),
        duration: duration,
      ));
    }
    return position1;
  }

  showResetDialog(String nameOfWinner) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              '$nameOfWinner WON.\nDo you want to start a new game?',
              textAlign: TextAlign.center,
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

  showOtherPlayerLeftAppDialog(String nameOfWinner) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              '$nameOfWinner has left the Game',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            content: Text('Do you also want to quit this Game?'),
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
                        initFunc(),
                        deleteUsersFromGameRoom(
                            widget.gameId, otherPlayerUserId!),
                        GameService().deleteGame(widget.gameId, widget.chatId),
                        widget.onEnd(),
                      },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }

  void rollDice(
      AsyncSnapshot snapshot, AsyncSnapshot otherPersonEngagedOfNotSnapshot) {
    number = 1 + Random().nextInt(6);
    if (otherPersonEngagedOfNotSnapshot.hasData &&
        otherPersonEngagedOfNotSnapshot.data['isEngaged'] == false) {
      return showOtherPlayerLeftAppDialog(
          otherPersonEngagedOfNotSnapshot.data['username']);
    }

    if (widget.players[0] == UserServices.userId) {
      print('User is First');
      if (snapshot.data['activePlayer'] == UserServices.userId) {
        if (snapshot.data[widget.players[1]] == 100) {
          checkwhoWon(snapshot.data[widget.players[1]], widget.players[1]);
        }
        int position1 = snapshot.data[widget.players[0]] + number;
        position1 =
            addAndDeleteIfFallOnSnakeOrLadder(position1, context, duration);
        position1 =
            dontAllowMovementIfPositionIsHigherThan100(position1, number);
        Map<String, dynamic> positionAndActivePlayerMap = {
          widget.players[0]: position1,
          widget.players[1]: snapshot.data[widget.players[1]],
          'activePlayer': widget.players[1]
        };
        snakeLadderDatabase().updateSnakeLadderPositionData(
            widget.gameId, positionAndActivePlayerMap);
        checkwhoWon(position1, widget.players[0]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Not Your Turn'), duration: duration));
      }
    }
    if (widget.players[1] == UserServices.userId) {
      print('User is Second');
      if (snapshot.data['activePlayer'] == UserServices.userId) {
        if (snapshot.data[widget.players[0]] == 100) {
          checkwhoWon(snapshot.data[widget.players[0]], widget.players[1]);
        }
        int position2 = snapshot.data[widget.players[1]] + number;
        position2 =
            addAndDeleteIfFallOnSnakeOrLadder(position2, context, duration);
        position2 =
            dontAllowMovementIfPositionIsHigherThan100(position2, number);
        print(position2);
        Map<String, dynamic> positionAndActivePlayerMap = {
          widget.players[0]: snapshot.data[widget.players[0]],
          widget.players[1]: position2,
          'activePlayer': widget.players[0]
        };
        snakeLadderDatabase().updateSnakeLadderPositionData(
            widget.gameId, positionAndActivePlayerMap);
        checkwhoWon(position2, widget.players[1]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Not Your Turn'), duration: duration));
      }
    }
  }

  checkwhoWon(int position, String nameOfWinner) async {
    if (position == 100) {
      await snakeLadderDatabase()
          .searchUserNamefromIdAndShowWinner(nameOfWinner)
          .then((value) {
        if (value != null) {
          showResetDialog(value);
        }
      });
    }
  }

  Widget Dice(
      AsyncSnapshot snapshot, AsyncSnapshot otherPersonEngagedOfNotSnapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          print("onpressed users data ${widget.players}");
          rollDice(snapshot, otherPersonEngagedOfNotSnapshot);
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
