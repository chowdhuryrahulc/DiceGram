// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/TikTakToe/TikTakToe/TikTakToeDatabase.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/new_snake_ladder/snakeLadderDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'customDialog.dart';
import 'gameButton.dart';

class TikTakToe extends StatefulWidget {
  const TikTakToe({
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
  State<TikTakToe> createState() => _TikTakToeState();
}

class _TikTakToeState extends State<TikTakToe> {
  Duration duration = Duration(milliseconds: 500);
  List<GameButton>? buttonsList;
  List<int> player1 = [];
  List<int> player2 = [];
  String? player1Name;
  String? player2Name;

  // String activePlayer = firstName!;
  TikTakToeDatabase tikTakToeDatabase = TikTakToeDatabase();

  Stream? getTikTakToeDataStream;

  @override
  void initState() {
    buttonsList = doInit();
    super.initState();
  }

  doInit() {
    // String activePlayer = firstName!;

    List<GameButton> gameButtons = [
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    Map<String, dynamic> activePlayerMap = {'activePlayer': widget.players[0]};
    tikTakToeDatabase.saveActivePlayerInFirestore(
        activePlayerMap, widget.gameId);

    String text = '';
    String bg = 'grey';
    bool enabled = false;

    for (var id = 1; id < 10; id++) {
      Map<String, dynamic> gameMap = {
        'id': id,
        'text': text,
        'background': bg,
        'enabled': enabled
      };
      tikTakToeDatabase.sendGameButtonData(widget.gameId, gameMap, id);
    }

    // tikTakToeDatabase.getButtonData(widget.gameId).then((value) {
    //   setState(() {
    //     getTikTakToeDataStream = value;
    //   });
    // });

    return gameButtons;
  }

  void playGame(AsyncSnapshot snapshot, GameButton gameButton, int id) async {
    tikTakToeDatabase.getStreamOfActivePlayerData(widget.gameId);

    String activePlayer =
        await tikTakToeDatabase.getActivePlayerData(widget.gameId);
    print('activePlayer');
    print(activePlayer);
    setState(() {
      if (widget.players[0] == UserServices.userId) {
        print('User is First');
        if (activePlayer == UserServices.userId) {
          print('Player is Active');
          Map<String, dynamic> updateButtonDataMap = {
            'id': id,
            'text': "X",
            'background': 'red',
            'enabled': gameButton.enabled
          };
          tikTakToeDatabase.updateGameButtonData(
              widget.gameId, updateButtonDataMap, gameButton.id);

          Map<String, String> playersListMap = {
            'activePlayer': widget.players[1],
          };
          print('widget.players[1]');
          print(widget.players[1]);
          print('widget.gameId');
          print(widget.gameId);

          tikTakToeDatabase.updateActivePlayerInFirestore(
              playersListMap, widget.gameId);

          checkWinner().then((value) {
            print('WINNERS');
            print(value);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Not Your Turn'), duration: duration));
        }
      }
      if (widget.players[1] == UserServices.userId) {
        print('User is Second');
        //print(snapshot.data['activePlayer']);
        if (activePlayer == UserServices.userId) {
          Map<String, dynamic> updateButtonDataMap = {
            'id': id,
            'text': "O",
            'background': 'black',
            'enabled': gameButton.enabled
          };
          tikTakToeDatabase.updateGameButtonData(
              widget.gameId, updateButtonDataMap, gameButton.id);

          Map<String, String> playersListMap = {
            'activePlayer': widget.players[0],
          };
          // tikTakToeDatabase.sendTikTakToeData(widget.gameId, playersListMap);

          // activePlayer = Provider.of<recieverNameProvider>(context, listen: false)
          //     .recieverName;
          //todo Uncomment this Later
          tikTakToeDatabase.updateActivePlayerInFirestore(
              playersListMap, widget.gameId);

          checkWinner().then((value) {
            print('WINNERS');
            print(value);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Not Your Turn'), duration: duration));
        }
      }
    });
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
              stream: tikTakToeDatabase.getButtonData(widget.gameId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            height: 300.h,
                            width: 300.w,
                            color: Colors.yellow,
                            child: GridView.builder(
                                padding: EdgeInsets.all(10),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1.0,
                                        crossAxisSpacing: 9.0,
                                        mainAxisSpacing: 9.sp),
                                itemCount:
                                    snapshot.data.docs.length, // 9 buttons
                                itemBuilder: (context, i) {
                                  return RaisedButton(
                                    padding: EdgeInsets.all(8.0),
                                    // if enabled, call a function
                                    onPressed: snapshot.data.docs[i]
                                                .data()['enabled'] ==
                                            false
                                        ? () {
                                            playGame(
                                                snapshot, buttonsList![i], i);
                                          }
                                        : null,
                                    child: Text(
                                      snapshot.data.docs[i].data()['text'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.sp,
                                      ),
                                    ),
                                    // Innitially grey
                                    color: snapshot.data.docs[i]
                                                .data()['background'] ==
                                            'grey'
                                        ? Colors.grey
                                        : snapshot.data.docs[i]
                                                    .data()['background'] ==
                                                'red'
                                            ? Colors.red
                                            : Colors.green,
                                    disabledColor: snapshot.data.docs[i]
                                                .data()['background'] ==
                                            'grey'
                                        ? Colors.grey
                                        : snapshot.data.docs[i]
                                                    .data()['background'] ==
                                                'red'
                                            ? Colors.red
                                            : Colors.green,
                                  );
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                FutureBuilder(
                                    future: snakeLadderDatabase()
                                        .searchUserNamefromIdAndShowInSnakeLadderGame(
                                            widget.players[0]),
                                    builder: (context,
                                        AsyncSnapshot futureSnapshot) {
                                      if (futureSnapshot.hasData) {
                                        return StreamBuilder(
                                            stream: tikTakToeDatabase
                                                .getStreamOfActivePlayerData(
                                                    widget.gameId),
                                            builder: (context,
                                                AsyncSnapshot
                                                    activePlayerSnapshot) {
                                              if (activePlayerSnapshot
                                                  .hasData) {
                                                player1Name = futureSnapshot
                                                    .data['username']
                                                    .toString();
                                                return Text(
                                                  futureSnapshot
                                                          .data['username']
                                                          .toString() +
                                                      '*',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: futureSnapshot
                                                                  .data['id'] ==
                                                              activePlayerSnapshot
                                                                      .data[
                                                                  'activePlayer']
                                                          ? Colors.green
                                                          : Colors.red),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            });
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                                FutureBuilder(
                                    future: snakeLadderDatabase()
                                        .searchUserNamefromIdAndShowInSnakeLadderGame(
                                            widget.players[1]),
                                    builder: (context,
                                        AsyncSnapshot futureSnapshot) {
                                      if (futureSnapshot.hasData) {
                                        player2Name = futureSnapshot
                                            .data['username']
                                            .toString();
                                        return StreamBuilder(
                                            stream: tikTakToeDatabase
                                                .getStreamOfActivePlayerData(
                                                    widget.gameId),
                                            builder: (context,
                                                AsyncSnapshot
                                                    activePlayerSnapshot) {
                                              if (activePlayerSnapshot
                                                  .hasData) {
                                                return Text(
                                                  futureSnapshot
                                                      .data['username']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: futureSnapshot
                                                                  .data['id'] ==
                                                              activePlayerSnapshot
                                                                      .data[
                                                                  'activePlayer']
                                                          ? Colors.green
                                                          : Colors.red),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            });
                                      } else {
                                        return SizedBox();
                                      }
                                    })
                              ],
                            ),
                            ElevatedButton(
                              onPressed: resetGame,
                              child: Text('Reset'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                buttonsList = doInit();
                                deleteUsersFromGameRoom(
                                    widget.gameId, otherPlayerUserId!);
                                GameService()
                                    .deleteGame(widget.gameId, widget.chatId);
                                widget.onEnd();
                              },
                              child: Text('End'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange)),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else
                  return Container();
              });
        });
  }

  Future<String> getPlayerListData(int id) async {
    var g = await tikTakToeDatabase.getPlayerListData(widget.gameId, id);
    return g;
  }

// Simple
  Future<int> checkWinner() async {
    var winner = -1;
    var id1 = await getPlayerListData(1);
    var id2 = await getPlayerListData(2);
    var id3 = await getPlayerListData(3);
    var id4 = await getPlayerListData(4);
    var id5 = await getPlayerListData(5);
    var id6 = await getPlayerListData(6);
    var id7 = await getPlayerListData(7);
    var id8 = await getPlayerListData(8);
    var id9 = await getPlayerListData(9);

    if (id1 == 'O' && id2 == 'O' && id3 == 'O') {
      winner = 1;
    }
    if (id1 == 'X' && id2 == 'X' && id3 == 'X') {
      winner = 2;
    }

    // row 2
    if (id4 == 'O' && id5 == 'O' && id6 == 'O') {
      winner = 1;
    }
    if (id4 == 'X' && id5 == 'X' && id6 == 'X') {
      winner = 2;
    }
//ROW 3
    if (id7 == 'O' && id8 == 'O' && id9 == 'O') {
      winner = 1;
    }
    if (id7 == 'X' && id8 == 'X' && id9 == 'X') {
      winner = 2;
    }

// Column 1
    if (id1 == 'O' && id4 == 'O' && id7 == 'O') {
      winner = 1;
    }
    if (id1 == 'X' && id4 == 'X' && id7 == 'X') {
      winner = 2;
    }

    // column 2
    if (id2 == 'O' && id5 == 'O' && id8 == 'O') {
      winner = 1;
    }
    if (id2 == 'X' && id5 == 'X' && id8 == 'X') {
      winner = 2;
    }
//column 3
    if (id3 == 'O' && id6 == 'O' && id9 == 'O') {
      winner = 1;
    }
    if (id3 == 'X' && id6 == 'X' && id9 == 'X') {
      winner = 2;
    }

// Digonal
    if (id1 == 'O' && id5 == 'O' && id9 == 'O') {
      winner = 1;
    }
    if (id1 == 'X' && id5 == 'X' && id9 == 'X') {
      winner = 2;
    }
//digonal 2
    if (id3 == 'O' && id5 == 'O' && id7 == 'O') {
      winner = 1;
    }
    if (id3 == 'X' && id5 == 'X' && id7 == 'X') {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("${player2Name} Won",
                    "Press the reset button to start again.", () {
                  doInit();
                  Navigator.pop(context);
                }));
      } else {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("${player1Name} Won",
                    "Press the reset button to start again.", () {
                  doInit();
                  Navigator.pop(context);
                }));
      }
    }
    return winner;
  }

  void resetGame() {
    buttonsList = doInit();
  }
}
